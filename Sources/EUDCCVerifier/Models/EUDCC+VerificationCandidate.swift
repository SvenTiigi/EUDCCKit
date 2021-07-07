import EUDCC
import Foundation

// MARK: - EUDCC+VerificationCandidate

public extension EUDCC {
    
    /// An EUDCC Verification Candidate
    struct VerificationCandidate: Hashable {
        
        // MARK: Properties
        
        /// The Signature
        public let signature: Data
        
        /// The SignedPayload
        public let signedPayload: SignedPayload
        
        /// The TrustCertificate
        public let trustCertificate: TrustCertificate
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.VerificationCandidate`
        /// - Parameters:
        ///   - signature: The EUDCC Signature
        ///   - signedPayload: The EUDCC SignedPayload
        ///   - trustCertificate: The EUDCC TrustCertificate
        public init(
            signature: Data,
            signedPayload: SignedPayload,
            trustCertificate: TrustCertificate
        ) {
            self.signature = signature
            self.signedPayload = signedPayload
            self.trustCertificate = trustCertificate
        }
        
    }
    
}

// MARK: - Verify

public extension EUDCC.VerificationCandidate {
    
    /// Verify Candidate
    /// - Returns: The verification result
    func verify() -> Bool {
        // Verify Public Key of TrustCertificate is available
        guard let publicKey = self.trustCertificate.publicKey else {
            // Oterhwise return false
            return false
        }
        // Initialize mutable Signature
        var signature = self.signature
        // Declare SecKeyAlgorithm
        let algorithm: SecKeyAlgorithm
        // Check PublicKey Algorithm
        if SecKeyIsAlgorithmSupported(
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
        } else if SecKeyIsAlgorithmSupported(
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
        let verificationResult = SecKeyVerifySignature(
            publicKey,
            algorithm,
            self.signedPayload.rawValue as NSData,
            signature as NSData,
            &error
        )
        // Release Error
        error?.release()
        // Return VerificationResult
        return verificationResult
    }
    
}
