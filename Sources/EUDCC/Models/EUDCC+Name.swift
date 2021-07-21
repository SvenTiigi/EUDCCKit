import Foundation

// MARK: - Name

public extension EUDCC {
    
    /// The EUDCC Person Name
    struct Name: Hashable {
        
        // MARK: Properties
        
        /// The optional first name
        public let firstName: String?
        
        /// The optional standardised first name
        public let standardisedFirstName: String?
        
        /// The optional last name
        public let lastName: String?

        /// The optional standardised last name
        public let standardisedLastName: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Person`
        /// - Parameters:
        ///   - firstName: The optional first name. Default value `nil`
        ///   - standardisedFirstName: The optional standardised first name. Default value `nil`
        ///   - lastName: The optional last name. Default value `nil`
        ///   - standardisedLastName: The standardised last name
        public init(
            firstName: String? = nil,
            standardisedFirstName: String? = nil,
            lastName: String? = nil,
            standardisedLastName: String
        ) {
            self.firstName = firstName
            self.standardisedFirstName = standardisedFirstName
            self.lastName = lastName
            self.standardisedLastName = standardisedLastName
        }
        
    }
    
}

// MARK: - Formatted

public extension EUDCC.Name {
    
    /// Retrieve the formatted full name
    /// - Parameters:
    ///   - formatter: The PersonNameComponentsFormatter. Default value `.init()`
    ///   - components: The PersonNameComponents. Default value `.init()`
    /// - Returns: The formatted full name
    func formatted(
        using formatter: PersonNameComponentsFormatter = .init(),
        components: PersonNameComponents = .init()
    ) -> String {
        var components = components
        components.givenName = self.firstName
        components.familyName = self.lastName
        return formatter.string(from: components)
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
