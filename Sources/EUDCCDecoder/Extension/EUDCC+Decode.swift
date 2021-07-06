import EUDCC
import Foundation

// MARK: - Convenience Decode

public extension EUDCC {
    
    /// Decode `EUDCC` from EUDCC String representation
    /// - Parameters:
    ///   - eudccStringRepresentation: The EUDCC String representation
    ///   - decoder: The `EUDCCDecoder`. Default value `.init()`
    /// - Returns: A Result contains either the successfully decoded EUDCC or an DecodingError
    static func decode(
        from eudccStringRepresentation: String,
        using decoder: EUDCCDecoder = .init()
    ) -> Result<Self, EUDCCDecoder.DecodingError> {
        decoder.decode(
            from: eudccStringRepresentation
        )
    }
    
}
