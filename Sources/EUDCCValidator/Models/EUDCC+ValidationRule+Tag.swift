import EUDCC
import Foundation

// MARK: - Tag

public extension EUDCC.ValidationRule {
    
    /// An EUDCC ValidationRule Tag
    struct Tag: Codable, Hashable {
        
        // MARK: Properties
        
        /// The tag name
        public let name: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.ValidationRule.Tag`
        /// - Parameter name: The tag name. Default value `UUID`
        public init(
            name: String = UUID().uuidString
        ) {
            self.name = name
        }
        
    }
    
}

// MARK: - CustomStringConvertible

extension EUDCC.ValidationRule.Tag: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        self.name
    }
    
}

// MARK: - ExpressibleByStringLiteral

extension EUDCC.ValidationRule.Tag: ExpressibleByStringInterpolation {
    
    /// Creates an instance initialized to the given string value.
    /// - Parameter value: The value of the new instance.
    public init(
        stringLiteral value: String
    ) {
        self.init(name: value)
    }
    
}

