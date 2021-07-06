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
        
        /// Creats a new instance of `EUDCC.SignedPayload`
        /// - Parameter cryptographicSignature: The EUDCC CryptographicSignature
        public init(
            cryptographicSignature: EUDCC.CryptographicSignature
        ) {
            self.rawValue = .init(
                SwiftCBOR.CBOR.encode(
                    [
                        "Signature1",
                        SwiftCBOR.CBOR
                            .byteString([UInt8](cryptographicSignature.protected)),
                        SwiftCBOR.CBOR
                            .byteString(.init()),
                        SwiftCBOR.CBOR
                            .byteString([UInt8](cryptographicSignature.payload))
                    ]
                )
            )
        }
        
    }
    
}
