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
