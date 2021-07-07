import EUDCC
import Foundation

// MARK: - EUDCCVerifier

/// An EUDCC Verifier
public final class EUDCCVerifier {
    
    // MARK: Properties
    
    /// The EUDCCTrustService
    let trustService: EUDCCTrustService
    
    // MARK: Initializer
    
    /// Creates a new instance of `EUDCCVerifier`
    /// - Parameter trustService: The EUDCCTrustService. Default value `EUCentralEUDCCTrustService()`
    public init(
        trustService: EUDCCTrustService = EUCentralEUDCCTrustService()
    ) {
        self.trustService = trustService
    }
    
}

// MARK: - VerificationResult

public extension EUDCCVerifier {
    
    /// The VerificationResult
    enum VerificationResult {
        /// Valid
        case success(EUDCC.TrustCertificate)
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
        /// TrustService Error
        case trustServiceError(Error)
        /// No matching TrustCertificate for EUDCC KeyID
        case noMatchingTrustCertificate(EUDCC.TrustCertificate.KeyID)
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
        guard let eudccKeyID = EUDCC.TrustCertificate.KeyID(
            cryptographicSignature: eudcc.cryptographicSignature
        ) else {
            // Otherwise complete with failure
            return completion(.failure(.malformedCertificateKeyID(eudcc)))
        }
        // Retrieve Certificates from TrustService
        self.trustService.getCertificates { result in
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
            // Declare TrustCertificates
            let trustCertificates: [EUDCC.TrustCertificate]
            // Switch on Result
            switch result {
            case .success(let certificates):
                // Initialize TrustCertificates
                trustCertificates = certificates
            case .failure(let error):
                // Complete with failure
                return complete(with: .failure(.trustServiceError(error)))
            }
            // Retrieve matching TrustCertificates by KeyID
            let matchingTrustCertificates = trustCertificates.filter { $0.keyID == eudccKeyID }
            // Verify matching TrustCertificates are not empty
            guard !matchingTrustCertificates.isEmpty else {
                // Otherwise complete with failure
                return complete(with: .failure(.noMatchingTrustCertificate(eudccKeyID)))
            }
            // Retrieve EUDCC Signature bytes
            let eudccSignature = Data(eudcc.cryptographicSignature.signature)
            // Initialize EUDCC SignedPayload
            let eudccSignedPayload = EUDCC.SignedPayload(cryptographicSignature: eudcc.cryptographicSignature)
            // Map matching SignerCertificates to VerificationCandidates
            let verificationCandidates: [EUDCC.VerificationCandidate] = matchingTrustCertificates
                .map { trustCertificate in
                    .init(
                        signature: eudccSignature,
                        signedPayload: eudccSignedPayload,
                        trustCertificate: trustCertificate
                    )
                }
            // Verify the first VerificationCandidate that is verified successfully is available
            guard let matchingVerificationCandidate = verificationCandidates.first(where: { $0.verify() }) else {
                // Otherwise complete with failure as no VerificationCandidate verified successfully
                return complete(with: .invalid)
            }
            // Complete with success
            return complete(with: .success(matchingVerificationCandidate.trustCertificate))
        }
    }
    
}
