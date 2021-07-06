import EUDCC
import Foundation
import SwiftCBOR

// MARK: - EUDCC+KeyID

public extension EUDCC.SignerCertificate {
    
    /// The EUDCC KeyID
    struct KeyID: Codable, Hashable {
        
        // MARK: Properties
        
        /// The key id String raw value
        public let rawValue: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.KeyID`
        /// - Parameter rawValue: The key id String raw value
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
    }
    
}

// MARK: Convenience Initializer with CryptographicSignature

public extension EUDCC.SignerCertificate.KeyID {
    
    /// Creats a new instance of `EUDCC.KeyID`
    /// - Parameter cryptographicSignature: The EUDCC CryptographicSignature
    init?(
        cryptographicSignature: EUDCC.CryptographicSignature
    ) {
        // Decode protected CBOR
        let protectedCBOR = try? SwiftCBOR.CBORDecoder(
            input: [UInt8](cryptographicSignature.protected)
        ).decodeItem()
        // Verify protected CBOR Map is available
        guard case .map(let protectedCBORMap) = protectedCBOR else {
            // Otherwise return nil
            return nil
        }
        // Map unprotected to CBOR Map
        let unprotectedCBORMap: [SwiftCBOR.CBOR : SwiftCBOR.CBOR] = Dictionary(
            uniqueKeysWithValues: cryptographicSignature
                .unprotected
                .compactMap { key, value in
                    // Verify Key and Value can be decoded
                    guard let key = try? SwiftCBOR.CBORDecoder(input: [UInt8](key)).decodeItem(),
                          let value = try? SwiftCBOR.CBORDecoder(input: [UInt8](value)).decodeItem() else {
                        // Otherwise return nil
                        return nil
                    }
                    // Return key and value
                    return (key, value)
                }
        )
        // Initialize KID Key
        let kidKey = SwiftCBOR.CBOR.unsignedInt(4)
        // Retrieve KID CBOR for key either from protected or unprotected CBOR Map
        let kidCBOR = protectedCBORMap[kidKey] ?? unprotectedCBORMap[kidKey]
        // Verify KID bytes are available
        guard case .byteString(let kidBytes) = kidCBOR else {
            // Otherwise return nil
            return nil
        }
        // Initialize KID Base-64 encoded string
        self.rawValue = Data(kidBytes.prefix(8)).base64EncodedString()
    }
    
}
