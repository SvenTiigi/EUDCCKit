import Foundation
import Compression

// MARK: - Data+decompress

extension Data {
    
    /// Retrieve a decompressed representation of the current Data object
    /// - Parameter algorithm: The Compression Algorithm that should be used. Default value `COMPRESSION_ZLIB`
    func decompressed(
        algorithm: compression_algorithm = COMPRESSION_ZLIB
    ) -> Self {
        guard self.count > 2 else {
            return self
        }
        let size = 4 * self.count + 8 * 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        let result = self.subdata(in: 2 ..< self.count).withUnsafeBytes {
            let read = Compression.compression_decode_buffer(
                buffer,
                size,
                $0.baseAddress!.bindMemory(to: UInt8.self, capacity: 1),
                self.count - 2,
                nil,
                algorithm
            )
            return .init(
                bytes: buffer,
                count: read
            )
        } as Data
        buffer.deallocate()
        return result
    }
    
}
