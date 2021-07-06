import EUDCC
import Foundation

// MARK: - EUDCCVerifier

/// An EUDCC Verifier
public final class EUDCCVerifier {
    
    // MARK: Properties
    
    /// The EUDCCSignerCertificateService
    let certificateService: EUDCCSignerCertificateService
    
    // MARK: Initializer
    
    /// Creates a new instance of `EUDCCVerifier`
    /// - Parameter certificateService: The EUDCCSignerCertificateService. Default value `EUCentralEUDCCSignerCertificateService`
    public init(
        certificateService: EUDCCSignerCertificateService = EUCentralEUDCCSignerCertificateService()
    ) {
        self.certificateService = certificateService
    }
    
}

// MARK: - VerificationResult

public extension EUDCCVerifier {
    
    /// The VerificationResult
    enum VerificationResult {
        /// Valid
        case success(EUDCC.SignerCertificate)
        /// Invalid
        case invalid
        /// Failure
        case failure(Failure)
    }
    
}

// MARK: - Failure

public extension EUDCCVerifier {
    
    /// The EUDCCVerifier Failure
    enum Failure: Error {
        /// Malformed Certificate KeyID from EUDCC
        case malformedCertificateKeyID(EUDCC)
        /// SignerCertificates Error
        case signerCertificatesError(Error)
        /// No matching SignertCertificate for EUDCC KeyID
        case noMatchingSignerCertificate(EUDCC.SignerCertificate.KeyID)
    }
    
}

// MARK: - Verify EUDCC

public extension EUDCCVerifier {
    
    /// Verify `EUDCC` and retrieve a `VerificationResult`
    /// - Parameters:
    ///   - eudcc: The `EUDCC` that should be verified
    ///   - completion: The completion handler taking in the `VerificationResult`
    func verify(
        eudcc: EUDCC,
        completion: @escaping (VerificationResult) -> Void
    ) {
        // Verify EUDCC KeyID is available from CryptographicSignature
        guard let eudccKeyID = EUDCC.SignerCertificate.KeyID(
            cryptographicSignature: eudcc.cryptographicSignature
        ) else {
            // Otherwise complete with failure
            return completion(.failure(.malformedCertificateKeyID(eudcc)))
        }
        // Retrieve Certificates
        self.certificateService.getCertificates { result in
            /// Complete with VerificationResult
            /// - Parameter verificationResult: The VerificationResult
            func complete(
                with verificationResult: VerificationResult
            ) {
                // Check if Thread is MainThred
                if Thread.isMainThread {
                    // Invoke completion with Verification
                    completion(verificationResult)
                } else {
                    // Dispatch on MainThread
                    DispatchQueue.main.async {
                        // Invoke completion with Verification
                        completion(verificationResult)
                    }
                }
            }
            // Declare SignerCertificates
            let signerCertificates: [EUDCC.SignerCertificate]
            // Switch on Result
            switch result {
            case .success(let certificates):
                // Initialize SignerCertificates
                signerCertificates = certificates
            case .failure(let error):
                // Complete with failure
                return complete(with: .failure(.signerCertificatesError(error)))
            }
            // Retrieve matching SignerCertificates by KeyID
            let matchingSignerCertificates = signerCertificates.filter { $0.keyID == eudccKeyID }
            // Verify matching SignerCertificates are not empty
            guard !matchingSignerCertificates.isEmpty else {
                // Otherwise complete with failure
                return complete(with: .failure(.noMatchingSignerCertificate(eudccKeyID)))
            }
            // Retrieve EUDCC Signature bytes
            let eudccSignature = Data(eudcc.cryptographicSignature.signature)
            // Initialize EUDCC SignedPayload
            let eudccSignedPayload = EUDCC.SignedPayload(cryptographicSignature: eudcc.cryptographicSignature)
            // Map matching SignerCertificates to VerificationCandidates
            let verificationCandidates: [EUDCC.VerificationCandidate] = matchingSignerCertificates
                .map { signerCertificate in
                    .init(
                        signature: eudccSignature,
                        signedPayload: eudccSignedPayload,
                        signerCertificate: signerCertificate
                    )
                }
            // Verify the first VerificationCandidate that is verified successfully is available
            guard let matchingVerificationCandidate = verificationCandidates.first(where: { $0.verify() }) else {
                // Otherwise complete with failure as no VerificationCandidate verified successfully
                return complete(with: .invalid)
            }
            // Complete with success
            return complete(with: .success(matchingVerificationCandidate.signerCertificate))
        }
    }
    
}
