import Foundation

// MARK: - TestResult

public extension EUDCC.Test {
    
    /// The EUDCC result of the test
    struct TestResult: Hashable {
        
        // MARK: Properties
        
        /// The string value
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Test.TestResult`
        /// - Parameter value: The string value
        public init(value: String) {
            self.value = value
        }
        
    }
    
}

// MARK: - WellKnownValue

public extension EUDCC.Test.TestResult {
    
    /// The WellKnownValue
    enum WellKnownValue: String, Codable, Hashable, CaseIterable {
        /// Not detected
        case notDetected = "260415000"
        /// Detected
        case detected = "260373001"
    }
    
    /// The WellKnownValue if available
    var wellKnownValue: WellKnownValue? {
        .init(rawValue: self.value)
    }
    
}

// MARK: - WellKnownValue+Convenience

public extension EUDCC.Test.TestResult.WellKnownValue {
    
    /// Positive TestResult value represented by `detected` case
    static let positive: Self = .detected
    
    /// Negative TestResult value represented by `notDetected` case
    static let negative: Self = .notDetected
    
}

// MARK: - Codable

extension EUDCC.Test.TestResult: Codable {
    
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
