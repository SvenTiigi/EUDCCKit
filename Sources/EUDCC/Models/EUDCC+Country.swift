import Foundation

// MARK: - Country

public extension EUDCC {
    
    /// The EUDCC Country
    struct Country: Hashable {
        
        // MARK: Properties
        
        /// The string value
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Test.Country`
        /// - Parameter value: The string value
        public init(value: String) {
            self.value = value
        }
        
    }
    
}

// MARK: - Localized String

public extension EUDCC.Country {
    
    /// Localized string of Country
    /// - Parameter locale: The Locale. Default value `.current`
    func localizedString(
        locale: Locale = .current
    ) -> String? {
        locale.localizedString(
            forRegionCode: self.value
        )
    }
    
}

// MARK: - Codable

extension EUDCC.Country: Codable {
    
    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
    
}
