import Foundation

// MARK: - Data+Base45

extension Data {
    
    /// The Base45 Encoding Error
    enum Base45EncodingError: Error {
        /// Invalid Character
        case invalidCharacter(Character)
        /// Invalid length
        case invalidLength
        /// Data overflow
        case dataOverflow
    }
    
    /// Initialize a `Data` from a Base-45 encoded String
    /// - Parameter base45String: The Base-45 encoded String
    /// - Throws: If decoding fails
    init(
        base45Encoded base45String: String
    ) throws {
        let base45Charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:"
        var base45EncodedData = Data()
        var base45DecodedData = Data()
        for character in base45String.uppercased() {
            guard let characterIndex = base45Charset.firstIndex(of: character) else {
                throw Base45EncodingError.invalidCharacter(character)
            }
            let index = base45Charset.distance(from: base45Charset.startIndex, to: characterIndex)
            base45EncodedData.append(UInt8(index))
        }
        for index in stride(from:0, to: base45EncodedData.count, by: 3) {
            if base45EncodedData.count - index < 2 {
                throw Base45EncodingError.invalidLength
            }
            var x = UInt32(base45EncodedData[index]) + UInt32(base45EncodedData[index + 1]) * 45
            if base45EncodedData.count - index >= 3 {
                x += 45 * 45 * .init(base45EncodedData[index + 2])
                guard x / 256 <= UInt8.max else {
                    throw Base45EncodingError.dataOverflow
                }
                base45DecodedData.append(.init(x / 256))
            }
            base45DecodedData.append(.init(x % 256))
        }
        self = base45DecodedData
    }
    
}
