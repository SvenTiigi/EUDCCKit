import EUDCC
import Foundation
import Security

// MARK: - EUDCC+TrustCertificate

public extension EUDCC {
    
    /// An EUDCC TrustCertificate
    struct TrustCertificate: Codable, Hashable {
        
        // MARK: Properties
        
        /// The KeyID
        public let keyID: KeyID
        
        /// The contents of the certificate
        public let contents: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.TrustCertificate`
        /// - Parameters:
        ///   - keyID: The KeyID
        ///   - contents: The contents of the certificate
        public init(
            keyID: KeyID,
            contents: String
        ) {
            self.keyID = keyID
            self.contents = contents
        }
        
    }
    
}

// MARK: - PublicKey

public extension EUDCC.TrustCertificate {
    
    /// The PublicKey from SignerCertificate contents if available
    var publicKey: Security.SecKey? {
        Data(
            base64Encoded: self.contents
        )
        .flatMap { Security.SecCertificateCreateWithData(nil, $0 as CFData) }
        .flatMap(Security.SecCertificateCopyKey)
    }
    
}
