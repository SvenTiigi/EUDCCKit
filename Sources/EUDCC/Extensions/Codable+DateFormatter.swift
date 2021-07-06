import Foundation

// MARK: - KeyedDecodingContainerProtocol+decode

extension KeyedDecodingContainerProtocol {
    
    /// Decodes a Date for the given key using a DateFormatter
    /// - Parameters:
    ///   - key: The Key
    ///   - dateFormatter: The DateFormatter
    func decode<DateFormatter: AnyDateFormatter>(
        forKey key: Key,
        using dateFormatter: DateFormatter
    ) throws -> Date where DateFormatter.Input: Decodable {
        let dateString = try self.decode(DateFormatter.Input.self, forKey: key)
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: [
                    String(describing: DateFormatter.self),
                    "unable to format date string",
                    "\(dateString)"
                ].joined(separator: " ")
            )
        }
        return date
    }
    
}

// MARK: - KeyedEncodingContainerProtocol+encodeEUDCCDate

extension KeyedEncodingContainerProtocol {
    
    /// Encodes a Date for the goven key using a DateFormatter
    /// - Parameters:
    ///   - date: The Date
    ///   - key: The Key
    ///   - dateFormatter: The DateFormatter
    mutating func encode<DateFormatter: AnyDateFormatter>(
        _ date: Date,
        forKey key: Key,
        using dateFormatter: DateFormatter
    ) throws where DateFormatter.Input: Encodable {
        try self.encode(
            dateFormatter.string(from: date),
            forKey: key
        )
    }
    
}
