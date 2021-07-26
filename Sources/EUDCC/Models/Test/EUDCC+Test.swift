import Foundation

// MARK: - Test

public extension EUDCC {
    
    /// The EUDCC Test Entry
    struct Test: Hashable {
        
        // MARK: Properties
        
        /// Disease or agent targeted
        public let diseaseAgentTargeted: DiseaseAgentTargeted
        
        /// Type of Test
        public let typeOfTest: TestType
        
        /// Test Name
        public let testName: String?
        
        /// RAT Test name and manufacturer
        public let testNameAndManufacturer: String?
        
        /// Date/Time of sample collection
        public let dateOfSampleCollection: Date
        
        /// Test Result
        public let testResult: TestResult
        
        /// Testing Centre
        public let testingCentre: String
        
        /// Country of Test
        public let countryOfTest: Country
        
        /// Certificate Issuer
        public let certificateIssuer: String
        
        /// Unique Certificate Identifier (UVCI)
        public let certificateIdentifier: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Test`
        /// - Parameters:
        ///   - diseaseAgentTargeted: Disease or agent targeted
        ///   - typeOfTest: Type of Test
        ///   - testName: Test Name
        ///   - testNameAndManufacturer: RAT Test name and manufacturer
        ///   - dateOfSampleCollection: Date/Time of sample collection
        ///   - testResult: Test Result
        ///   - testingCentre: Testing Centre
        ///   - countryOfTest: Country of Test
        ///   - certificateIssuer: Certificate Issuer
        ///   - certificateIdentifier: Unique Certificate Identifier (UVCI)
        public init(
            diseaseAgentTargeted: DiseaseAgentTargeted,
            typeOfTest: TestType,
            testName: String?,
            testNameAndManufacturer: String?,
            dateOfSampleCollection: Date,
            testResult: TestResult,
            testingCentre: String,
            countryOfTest: Country,
            certificateIssuer: String,
            certificateIdentifier: String
        ) {
            self.diseaseAgentTargeted = diseaseAgentTargeted
            self.typeOfTest = typeOfTest
            self.testName = testName
            self.testNameAndManufacturer = testNameAndManufacturer
            self.dateOfSampleCollection = dateOfSampleCollection
            self.testResult = testResult
            self.testingCentre = testingCentre
            self.countryOfTest = countryOfTest
            self.certificateIssuer = certificateIssuer
            self.certificateIdentifier = certificateIdentifier
        }
        
    }
    
}

// MARK: - Codable

extension EUDCC.Test: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case diseaseAgentTargeted = "tg"
        case typeOfTest = "tt"
        case testName = "nm"
        case testNameAndManufacturer = "ma"
        case dateOfSampleCollection = "sc"
        case testResult = "tr"
        case testingCentre = "tc"
        case countryOfTest = "co"
        case certificateIssuer = "is"
        case certificateIdentifier = "ci"
    }
    
    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.diseaseAgentTargeted = try container.decode(EUDCC.DiseaseAgentTargeted.self, forKey: .diseaseAgentTargeted)
        self.typeOfTest = try container.decode(TestType.self, forKey: .typeOfTest)
        self.testName = try container.decodeIfPresent(String.self, forKey: .testName)
        self.testNameAndManufacturer = try container.decodeIfPresent(String.self, forKey: .testNameAndManufacturer)
        self.dateOfSampleCollection = try container.decode(forKey: .dateOfSampleCollection, using: EUDCCDateFormatter.default)
        self.testResult = try container.decode(TestResult.self, forKey: .testResult)
        self.testingCentre = try container.decode(String.self, forKey: .testingCentre)
        self.countryOfTest = try container.decode(EUDCC.Country.self, forKey: .countryOfTest)
        self.certificateIssuer = try container.decode(String.self, forKey: .certificateIssuer)
        self.certificateIdentifier = try container.decode(String.self, forKey: .certificateIdentifier)
    }
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.diseaseAgentTargeted, forKey: .diseaseAgentTargeted)
        try container.encode(self.typeOfTest, forKey: .typeOfTest)
        try container.encode(self.testName, forKey: .testName)
        try container.encode(self.testNameAndManufacturer, forKey: .testNameAndManufacturer)
        try container.encode(self.dateOfSampleCollection, forKey: .dateOfSampleCollection, using: EUDCCDateFormatter.default)
        try container.encode(self.testResult, forKey: .testResult)
        try container.encode(self.testingCentre, forKey: .testingCentre)
        try container.encode(self.countryOfTest, forKey: .countryOfTest)
        try container.encode(self.certificateIssuer, forKey: .certificateIssuer)
        try container.encode(self.certificateIdentifier, forKey: .certificateIdentifier)
    }
    
}
