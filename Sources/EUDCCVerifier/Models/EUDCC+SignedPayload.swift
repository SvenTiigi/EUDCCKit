import EUDCC
import Foundation
import SwiftCBOR

// MARK: - SignedPayload

public extension EUDCC {
    
    /// The EUDCC SignedPayload
    struct SignedPayload: Codable, Hashable {
        
        // MARK: Properties
        
        /// The signed payload data raw value
        public let rawValue: Data
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.SignedPayload`
        /// - Parameters:
        ///   - prefix: The SignedPayload prefix. Default value `Signature1`
        ///   - cryptographicSignature: The EUDCC CryptographicSignature
        public init(
            prefix: String = "Signature1",
            cryptographicSignature: EUDCC.CryptographicSignature
        ) {
            self.rawValue = .init(
                SwiftCBOR.CBOR.encode(
                    [
                        .init(stringLiteral: prefix),
                        SwiftCBOR.CBOR
                            .byteString(.init(cryptographicSignature.protected)),
                        SwiftCBOR.CBOR
                            .byteString(.init()),
                        SwiftCBOR.CBOR
                            .byteString(.init(cryptographicSignature.payload))
                    ]
                )
            )
        }
        
    }
    
}
