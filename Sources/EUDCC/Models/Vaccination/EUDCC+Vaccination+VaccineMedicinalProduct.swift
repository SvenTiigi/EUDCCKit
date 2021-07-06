import Foundation

// MARK: - VaccineMedicinalProduct

public extension EUDCC.Vaccination {
    
    /// The EUDCC vaccination medicinal product used for this specific dose of vaccination
    struct VaccineMedicinalProduct: Hashable {
        
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

public extension EUDCC.Vaccination.VaccineMedicinalProduct {
    
    /// The WellKnownValue
    enum WellKnownValue: String, Codable, Hashable, CaseIterable {
        /// Comirnaty
        case comirnaty = "EU/1/20/1528"
        /// COVID-19 Vaccine Moderna
        case covid19VaccineModerna = "EU/1/20/1507"
        /// Vaxzevria
        case vaxzevria = "EU/1/21/1529"
        /// COVID-19 Vaccine Janssen
        case covid19VaccineJanssen = "EU/1/20/1525"
        /// CVnCoV
        case cvnCoV = "CVnCoV"
        /// Sputnik-V
        case sputnikV = "Sputnik-V"
        /// Convidecia
        case convidecia = "Convidecia"
        /// EpiVacCorona
        case epiVacCorona = "EpiVacCorona"
        /// BBIBP-CorV
        case bbibpCorV = "BBIBP-CorV"
        /// Inactivated SARS-CoV-2 (Vero Cell)
        case inactivatedSARSCoV2VeroCell = "Inactivated-SARS-CoV-2-Vero-Cell"
        /// CoronaVac
        case coronaVac = "CoronaVac"
        /// Covaxin (also known as BBV152 A, B, C
        case covaxin = "Covaxin"
    }
    
    /// The WellKnownValue if available
    var wellKnownValue: WellKnownValue? {
        .init(rawValue: self.value)
    }
    
}

// MARK: - WellKnownValue+Convenience

public extension EUDCC.Vaccination.VaccineMedicinalProduct.WellKnownValue {
    
    /// AstraZeneca represented by `vaxzevria` case
    static let astraZeneca: Self = .vaxzevria
    
}

// MARK: - Codable

extension EUDCC.Vaccination.VaccineMedicinalProduct: Codable {
    
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
