import Foundation

// MARK: - Name

public extension EUDCC {
    
    /// The EUDCC Person Name
    struct Name: Hashable {
        
        // MARK: Properties
        
        /// The first name
        public let firstName: String
        
        /// The standardised first name
        public let standardisedFirstName: String
        
        /// The last name
        public let lastName: String

        /// The standardised last name
        public let standardisedLastName: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Person`
        /// - Parameters:
        ///   - firstName: The first name
        ///   - standardisedFirstName: The standardised first name
        ///   - lastName: The last name
        ///   - standardisedLastName: The standardised last name
        public init(
            firstName: String,
            standardisedFirstName: String,
            lastName: String,
            standardisedLastName: String
        ) {
            self.firstName = firstName
            self.standardisedFirstName = standardisedFirstName
            self.lastName = lastName
            self.standardisedLastName = standardisedLastName
        }
        
    }
    
}

// MARK: - Codable

extension EUDCC.Name: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case firstName = "gn"
        case standardisedFirstName = "gnt"
        case lastName = "fn"
        case standardisedLastName = "fnt"
    }
    
}
