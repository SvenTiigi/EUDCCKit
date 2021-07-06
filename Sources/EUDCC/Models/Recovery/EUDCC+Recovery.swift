import Foundation

// MARK: - Recovery

public extension EUDCC {
    
    /// The EUDCC Recovery Entry
    struct Recovery: Hashable {
        
        // MARK: Properties
        
        /// Disease or agent targeted
        public let diseaseAgentTargeted: DiseaseAgentTargeted
        
        /// Date of first positive NAA test result
        public let dateOfFirstPositiveTestResult: Date
        
        /// Country of Test
        public let countryOfTest: Country
        
        /// Certificate issuer
        public let certificateIssuer: String
        
        /// Certificate Valid From
        public let certificateValidFrom: Date
        
        /// Certificate Valid Until
        public let certificateValidUntil: Date
        
        /// Unique Certificate Identifier (UVCI)
        public let certificateIdentifier: String
        
        /// Creates a new instance of `EUDCC.Recovery`
        /// - Parameters:
        ///   - diseaseAgentTargeted: Disease or agent targeted
        ///   - dateOfFirstPositiveTestResult: Date of first positive NAA test result
        ///   - countryOfTest: Country of Test
        ///   - certificateIssuer: Certificate issuer
        ///   - certificateValidFrom: Certificate Valid From
        ///   - certificateValidUntil: Certificate Valid Until
        ///   - certificateIdentifier: Unique Certificate Identifier (UVCI)
        public init(
            diseaseAgentTargeted: DiseaseAgentTargeted,
            dateOfFirstPositiveTestResult: Date,
            countryOfTest: Country,
            certificateIssuer: String,
            certificateValidFrom: Date,
            certificateValidUntil: Date,
            certificateIdentifier: String
        ) {
            self.diseaseAgentTargeted = diseaseAgentTargeted
            self.dateOfFirstPositiveTestResult = dateOfFirstPositiveTestResult
            self.countryOfTest = countryOfTest
            self.certificateIssuer = certificateIssuer
            self.certificateValidFrom = certificateValidFrom
            self.certificateValidUntil = certificateValidUntil
            self.certificateIdentifier = certificateIdentifier
        }
        
    }
    
}

// MARK: - Codable

extension EUDCC.Recovery: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case diseaseAgentTargeted = "tg"
        case dateOfFirstPositiveTestResult = "fr"
        case countryOfTest = "co"
        case certificateIssuer = "is"
        case certificateValidFrom = "df"
        case certificateValidUntil = "du"
        case certificateIdentifier = "ci"
    }
    
    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.diseaseAgentTargeted = try container.decode(EUDCC.DiseaseAgentTargeted.self, forKey: .diseaseAgentTargeted)
        self.dateOfFirstPositiveTestResult = try container.decode(forKey: .dateOfFirstPositiveTestResult, using: EUDCCDateFormatter.default)
        self.countryOfTest = try container.decode(EUDCC.Country.self, forKey: .countryOfTest)
        self.certificateIssuer = try container.decode(String.self, forKey: .certificateIssuer)
        self.certificateValidFrom = try container.decode(forKey: .certificateValidFrom, using: EUDCCDateFormatter.default)
        self.certificateValidUntil = try container.decode(forKey: .certificateValidUntil, using: EUDCCDateFormatter.default)
        self.certificateIdentifier = try container.decode(String.self, forKey: .certificateIdentifier)
    }
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.diseaseAgentTargeted, forKey: .diseaseAgentTargeted)
        try container.encode(self.dateOfFirstPositiveTestResult, forKey: .dateOfFirstPositiveTestResult, using: EUDCCDateFormatter.default)
        try container.encode(self.countryOfTest, forKey: .countryOfTest)
        try container.encode(self.certificateIssuer, forKey: .certificateIssuer)
        try container.encode(self.certificateValidFrom, forKey: .certificateValidFrom, using: EUDCCDateFormatter.default)
        try container.encode(self.certificateValidUntil, forKey: .certificateValidUntil, using: EUDCCDateFormatter.default)
        try container.encode(self.certificateIdentifier, forKey: .certificateIdentifier)
    }
    
}
