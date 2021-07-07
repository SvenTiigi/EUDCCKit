import Foundation

// MARK: - Data+encodedASN1

extension Data {
    
    /// Encode Data as ASN.1
    /// - Parameter digestLengthInBytes: The digest length in bytes. Default value `32`
    /// - Returns: The ASN.1 encoded Data if available
    func encodedASN1(
        digestLengthInBytes: Int = 32
    ) -> Data? {
        func encodeInt(_ data: [UInt8]) -> [UInt8] {
            guard !data.isEmpty else {
                return data
            }
            let firstBitIsSet: UInt8 = 0b10000000
            let tagInteger: UInt8 = 0x02
            if data[0] >= firstBitIsSet {
                return [tagInteger, UInt8(data.count + 1)] + [0] + data
            } else if data.first == 0x00 {
                return encodeInt([UInt8](data.dropFirst()))
            } else {
                return [tagInteger, UInt8(data.count)] + data
            }
        }
        func length(_ num: Int) -> [UInt8] {
            var bits = 0
            var numBits = num
            while numBits > 0 {
                numBits = numBits >> 1
                bits += 1
            }
            var bytes: [UInt8] = .init()
            var num = num
            while num > 0 {
                bytes += [UInt8(num & 0b11111111)]
                num = num >> 8
            }
            return [0b10000000 + UInt8((bits - 1) / 8 + 1)] + bytes.reversed()
        }
        let data = [UInt8](self)
        guard data.count > digestLengthInBytes else {
            return nil
        }
        let sigR = encodeInt([UInt8](data.prefix(data.count - digestLengthInBytes)))
        let sigS = encodeInt([UInt8](data.suffix(digestLengthInBytes)))
        let tagSequence: UInt8 = 0x30
        if sigR.count + sigS.count < 128 {
            return .init([tagSequence, UInt8(sigR.count + sigS.count)] + sigR + sigS)
        } else {
            return .init([tagSequence] + length(sigR.count + sigS.count) + sigR + sigS)
        }
    }
    
}
