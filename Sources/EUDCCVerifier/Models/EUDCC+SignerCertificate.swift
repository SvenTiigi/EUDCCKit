import EUDCC
import Foundation

// MARK: - EUDCC+SignerCertificate

public extension EUDCC {
    
    /// An EUDCC SignerCertificate
    struct SignerCertificate: Codable, Hashable {
        
        // MARK: Properties
        
        /// The KeyID
        public let keyID: KeyID
        
        /// The contents of the certificate
        public let contents: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.SignerCertificate`
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

public extension EUDCC.SignerCertificate {
    
    /// The PublicKey from SignerCertificate contents if available
    var publicKey: SecKey? {
        Data(
            base64Encoded: self.contents
        )
        .flatMap { SecCertificateCreateWithData(nil, $0 as CFData) }
        .flatMap(SecCertificateCopyKey)
    }
    
}
