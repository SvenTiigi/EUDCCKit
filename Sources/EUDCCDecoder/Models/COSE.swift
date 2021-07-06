import Foundation
import SwiftCBOR

// MARK: - COSE

/// The CBOR Object Signing and Encryption (COSE)
struct COSE: Hashable {
    
    /// The protected parameter
    let protected: [UInt8]
    
    /// The unprotected parameter
    let unprotected: [SwiftCBOR.CBOR: SwiftCBOR.CBOR]
    
    /// The payload parameter
    let payload: [UInt8]
    
    /// The signature parameter
    let signature: [UInt8]
    
}
