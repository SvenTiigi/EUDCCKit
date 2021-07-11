import EUDCC
import Foundation
import Security

// MARK: - EUDCCVerifier

/// An EUDCC Verifier
public struct EUDCCVerifier {
    
    // MARK: Properties
    
    /// The EUDCCTrustService
    let trustService: EUDCCTrustService
    
    // MARK: Initializer
    
    /// Creates a new instance of `EUDCCVerifier`
    /// - Parameter trustService: The EUDCCTrustService
    public init(
        trustService: EUDCCTrustService
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
        // Retrieve TrustCertificates from TrustService
        self.trustService.getTrustCertificates { result in
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
            // Switch on Result
            switch result {
            case .success(let trustCertificates):
                // Verify EUDCC against TrustCertificates
                let verificationResult = self.verify(
                    eudcc: eudcc,
                    against: trustCertificates
                )
                // Complete with VerificationResult
                complete(with: verificationResult)
            case .failure(let error):
                // Complete with failure
                complete(with: .failure(.trustServiceError(error)))
            }
        }
    }
    
}

// MARK: - Verify against TrustCertificates

public extension EUDCCVerifier {
    
    /// Verify EUDCC against a given sequence of EUDCC TrustCertificates
    /// - Parameters:
    ///   - eudcc: The EUDCC
    ///   - trustCertificates: The sequence of EUDCC TrustCertificate
    /// - Returns: A VerificationResult
    func verify<Certificates: Sequence>(
        eudcc: EUDCC,
        against trustCertificates: Certificates
    ) -> VerificationResult where Certificates.Element == EUDCC.TrustCertificate {
        // Verify EUDCC KeyID is available from CryptographicSignature
        guard let eudccKeyID = EUDCC.TrustCertificate.KeyID(
            cryptographicSignature: eudcc.cryptographicSignature
        ) else {
            // Otherwise complete with failure
            return .failure(.malformedCertificateKeyID(eudcc))
        }
        // Retrieve matching TrustCertificates by KeyID
        let matchingTrustCertificates = trustCertificates.filter { $0.keyID == eudccKeyID }
        // Verify matching TrustCertificates are not empty
        guard !matchingTrustCertificates.isEmpty else {
            // Otherwise complete with failure
            return .failure(.noMatchingTrustCertificate(eudccKeyID))
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
        guard let matchingVerificationCandidate = verificationCandidates.first(where: self.verify) else {
            // Otherwise complete with failure as no VerificationCandidate verified successfully
            return .invalid
        }
        // Complete with success
        return .success(matchingVerificationCandidate.trustCertificate)
    }
    
}

// MARK: - Verify EUDCC VerificationCandidate

public extension EUDCCVerifier {
    
    /// Verify EUDCC VerificationCandidate
    /// - Parameter candidate: The EUDCC VerificationCandidate that should be verified
    /// - Returns: Bool value if VerificationCandidate verified successfully
    func verify(
        candidate: EUDCC.VerificationCandidate
    ) -> Bool {
        // Verify Public Key of TrustCertificate is available
        guard let publicKey = candidate.trustCertificate.publicKey else {
            // Oterhwise return false
            return false
        }
        // Initialize mutable Signature
        var signature = candidate.signature
        // Declare SecKeyAlgorithm
        let algorithm: Security.SecKeyAlgorithm
        // Check PublicKey Algorithm
        if Security.SecKeyIsAlgorithmSupported(
            publicKey,
            .verify,
            .ecdsaSignatureMessageX962SHA256
        ) {
            // Use X962
            algorithm = .ecdsaSignatureMessageX962SHA256
            // Verify encoded ASN1 Signature is available
            guard let encodedASN1Signature = signature.encodedASN1() else {
                // Otherwise return falses
                return false
            }
            // Mutate Signature with encoded ASN1
            signature = encodedASN1Signature
        } else if Security.SecKeyIsAlgorithmSupported(
            publicKey,
            .verify, .rsaSignatureMessagePSSSHA256
        ) {
            // Use PSS
            algorithm = .rsaSignatureMessagePSSSHA256
        } else {
            // Otherwise return false as Algorithm is not supported
            return false
        }
        // Declare Error
        var error: Unmanaged<CFError>?
        // Verify Signature
        let verificationResult = Security.SecKeyVerifySignature(
            publicKey,
            algorithm,
            candidate.signedPayload.rawValue as NSData,
            signature as NSData,
            &error
        )
        // Release Error
        error?.release()
        // Return VerificationResult
        return verificationResult
    }
    
}
