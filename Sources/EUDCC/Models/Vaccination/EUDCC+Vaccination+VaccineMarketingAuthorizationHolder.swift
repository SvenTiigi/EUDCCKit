import Foundation

// MARK: - VaccineMarketingAuthorizationHolder

public extension EUDCC.Vaccination {
    
    /// The EUDCC vaccination vaccine marketing authorisation holder or manufacturer
    struct VaccineMarketingAuthorizationHolder: Hashable {
        
        // MARK: Properties
        
        /// The string value
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Vaccination.VaccineMedicinalProduct`
        /// - Parameter value: The string value
        public init(value: String) {
            self.value = value
        }
        
    }
    
}

// MARK: - WellKnownValue

public extension EUDCC.Vaccination.VaccineMarketingAuthorizationHolder {
    
    /// The WellKnownValue
    enum WellKnownValue: String, Codable, Hashable, CaseIterable {
        /// AstraZeneca AB
        case astraZenecaAB = "ORG-100001699"
        /// Biontech Manufacturing GmbH
        case biontechManufacturingGmbH = "ORG-100030215"
        /// Janssen-Cilag International
        case janssenCilagInternational = "ORG-100001417"
        /// Moderna Biotech Spain S.L.
        case modernaBiotechSpainSL = "ORG-100031184"
        /// Curevac AG
        case curevacAG = "ORG-100006270"
        /// CanSino Biologics
        case canSinoBiologics = "ORG-100013793"
        /// China Sinopharm International Corp. - Beijing location
        case chinaSinopharmInternationalCorp = "ORG-100020693"
        /// Sinopharm Weiqida Europe Pharmaceutical s.r.o. - Prague location
        case sinopharmWeiqidaEuropePharmaceutical = "ORG-100010771"
        /// Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen location
        case sinopharmZhijunPharmaceuticalCoLtd = "ORG-100024420"
        /// Novavax CZ AS
        case novavaxCzAs = "ORG-100032020"
        /// Gamaleya Research Institute
        case gamaleyaResearchInstitute = "Gamaleya-Research-Institute"
        /// Vector Institute
        case vectorInstitute = "Vector-Institute"
        /// Sinovac Biotech
        case sinovacBiotech = "Sinovac-Biotech"
        /// Bharat Biotech
        case bharatBiotech = "Bharat-Biotech"
    }
    
    /// The WellKnownValue if available
    var wellKnownValue: WellKnownValue? {
        .init(rawValue: self.value)
    }
    
}

// MARK: - Codable

extension EUDCC.Vaccination.VaccineMarketingAuthorizationHolder: Codable {
    
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
