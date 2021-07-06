import Foundation

// MARK: - CryptographicSignature

public extension EUDCC {
    
    /// The EUDCC CryptographicSignature
    struct CryptographicSignature: Codable, Hashable {
        
        // MARK: Properties
        
        /// The protected parameter
        public let protected: Data
        
        /// The unprotected parameter
        public let unprotected: [Data: Data]
        
        /// The payload parameter
        public let payload: Data
        
        /// The signature parameter
        public let signature: Data
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.CryptographicSignature`
        /// - Parameters:
        ///   - protected: The protected paramter
        ///   - unprotected: The unprotected paramter
        ///   - payload: The payload parameter
        ///   - signature: The signature parameter
        public init(
            protected: Data,
            unprotected: [Data: Data],
            payload: Data,
            signature: Data
        ) {
            self.protected = protected
            self.unprotected = unprotected
            self.payload = payload
            self.signature = signature
        }
        
    }
    
}
