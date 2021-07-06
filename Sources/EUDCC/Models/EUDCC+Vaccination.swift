import Foundation

// MARK: - Vaccination

public extension EUDCC {
    
    /// The EUDCC Vaccination Entry
    struct Vaccination: Hashable {
        
        // MARK: Properties
        
        /// Disease or agent targeted
        public let diseaseAgentTargeted: String
        
        /// Vaccine or prophylaxis
        public let vaccineOrProphylaxis: String
        
        /// Vaccine medicinal product
        public let vaccineMedicinalProduct: String
        
        /// Vaccine Marketing Authorization Holder
        public let vaccineMarketingAuthorizationHolder: String
        
        /// Dose Number
        public let doseNumber: Int
        
        /// Total Series of Doses
        public let totalSeriesOfDoses: Int
        
        /// Date of Vaccination
        public let dateOfVaccination: Date
        
        /// Country of Vaccination
        public let countryOfVaccination: String
        
        /// Certificate Issuer
        public let certificateIssuer: String
        
        /// Unique Certificate Identifier (UVCI)
        public let certificateIdentifier: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Vaccination`
        /// - Parameters:
        ///   - diseaseAgentTargeted: Disease or agent targeted
        ///   - vaccineOrProphylaxis: Vaccine or prophylaxis
        ///   - vaccineMedicinalProduct: Vaccine medicinal product
        ///   - vaccineMarketingAuthorizationHolder: Vaccine Marketing Authorization Holder
        ///   - doseNumber: Dose Number
        ///   - totalSeriesOfDoses: Total Series of Doses
        ///   - dateOfVaccination: Date of Vaccination
        ///   - countryOfVaccination: Country of Vaccination
        ///   - certificateIssuer: Certificate Issuer
        ///   - certificateIdentifier: Unique Certificate Identifier (UVCI)
        public init(
            diseaseAgentTargeted: String,
            vaccineOrProphylaxis: String,
            vaccineMedicinalProduct: String,
            vaccineMarketingAuthorizationHolder: String,
            doseNumber: Int,
            totalSeriesOfDoses: Int,
            dateOfVaccination: Date,
            countryOfVaccination: String,
            certificateIssuer: String,
            certificateIdentifier: String
        ) {
            self.diseaseAgentTargeted = diseaseAgentTargeted
            self.vaccineOrProphylaxis = vaccineOrProphylaxis
            self.vaccineMedicinalProduct = vaccineMedicinalProduct
            self.vaccineMarketingAuthorizationHolder = vaccineMarketingAuthorizationHolder
            self.doseNumber = doseNumber
            self.totalSeriesOfDoses = totalSeriesOfDoses
            self.dateOfVaccination = dateOfVaccination
            self.countryOfVaccination = countryOfVaccination
            self.certificateIssuer = certificateIssuer
            self.certificateIdentifier = certificateIdentifier
        }
        
    }
    
}

// MARK: - Codable

extension EUDCC.Vaccination: Codable {
    
    /// The CodingKeys
    private enum CodingKeys: String, CodingKey {
        case diseaseAgentTargeted = "tg"
        case vaccineOrProphylaxis = "vp"
        case vaccineMedicinalProduct = "mp"
        case vaccineMarketingAuthorizationHolder = "ma"
        case doseNumber = "dn"
        case totalSeriesOfDoses = "sd"
        case dateOfVaccination = "dt"
        case countryOfVaccination = "co"
        case certificateIssuer = "is"
        case certificateIdentifier = "ci"
    }
    
    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.diseaseAgentTargeted = try container.decode(String.self, forKey: .diseaseAgentTargeted)
        self.vaccineOrProphylaxis = try container.decode(String.self, forKey: .vaccineOrProphylaxis)
        self.vaccineMedicinalProduct = try container.decode(String.self, forKey: .vaccineMedicinalProduct)
        self.vaccineMarketingAuthorizationHolder = try container.decode(String.self, forKey: .vaccineMarketingAuthorizationHolder)
        self.doseNumber = try container.decode(Int.self, forKey: .doseNumber)
        self.totalSeriesOfDoses = try container.decode(Int.self, forKey: .totalSeriesOfDoses)
        self.dateOfVaccination = try container.decode(forKey: .dateOfVaccination, using: EUDCCDateFormatter.default)
        self.countryOfVaccination = try container.decode(String.self, forKey: .countryOfVaccination)
        self.certificateIssuer = try container.decode(String.self, forKey: .certificateIssuer)
        self.certificateIdentifier = try container.decode(String.self, forKey: .certificateIdentifier)
    }
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.diseaseAgentTargeted, forKey: .diseaseAgentTargeted)
        try container.encode(self.vaccineOrProphylaxis, forKey: .vaccineOrProphylaxis)
        try container.encode(self.vaccineMedicinalProduct, forKey: .vaccineMedicinalProduct)
        try container.encode(self.vaccineMarketingAuthorizationHolder, forKey: .vaccineMarketingAuthorizationHolder)
        try container.encode(self.doseNumber, forKey: .doseNumber)
        try container.encode(self.totalSeriesOfDoses, forKey: .totalSeriesOfDoses)
        try container.encode(self.dateOfVaccination, forKey: .dateOfVaccination, using: EUDCCDateFormatter.default)
        try container.encode(self.countryOfVaccination, forKey: .countryOfVaccination)
        try container.encode(self.certificateIssuer, forKey: .certificateIssuer)
        try container.encode(self.certificateIdentifier, forKey: .certificateIdentifier)
    }
    
}
