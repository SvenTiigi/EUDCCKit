import Foundation

// MARK: - DiseaseAgentTargeted

public extension EUDCC {
    
    /// The EUDCC disease or agent targeted
    struct DiseaseAgentTargeted: Hashable {
        
        // MARK: Properties
        
        /// The string value
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.DiseaseAgentTargeted`
        /// - Parameter value: The string value
        public init(value: String) {
            self.value = value
        }
        
    }
    
}

// MARK: - WellKnownValue

public extension EUDCC.DiseaseAgentTargeted {
    
    /// The WellKnownValue
    enum WellKnownValue: String, Codable, Hashable, CaseIterable {
        /// COVID-19
        case covid19 = "840539006"
    }
    
    /// The WellKnownValue if available
    var wellKnownValue: WellKnownValue? {
        .init(rawValue: self.value)
    }
    
}

// MARK: - Codable

extension EUDCC.DiseaseAgentTargeted: Codable {
    
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
