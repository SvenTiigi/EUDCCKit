import Foundation

// MARK: - VaccineOrProphylaxis

public extension EUDCC.Vaccination {
    
    /// The EUDCC vaccination type of the vaccine or prophylaxis used.
    struct VaccineOrProphylaxis: Hashable {
        
        // MARK: Properties
        
        /// The string value
        public let value: String
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCC.Vaccination.VaccineOrProphylaxis`
        /// - Parameter value: The string value
        public init(value: String) {
            self.value = value
        }
        
    }
    
}

// MARK: - WellKnownValue

public extension EUDCC.Vaccination.VaccineOrProphylaxis {
    
    /// The WellKnownValue
    enum WellKnownValue: String, Codable, Hashable, CaseIterable {
        /// SARS-CoV-2 mRNA vaccine
        case sarsCoV2mRNAVaccine = "1119349007"
        /// SARS-CoV-2 antigen Vaccine
        case sarsCoV2AntigenVaccine = "1119305005"
        /// COVID-19 vaccines
        case covid19Vaccines = "J07BX03"
    }
    
    /// The WellKnownValue if available
    var wellKnownValue: WellKnownValue? {
        .init(rawValue: self.value)
    }
    
}

// MARK: - Codable

extension EUDCC.Vaccination.VaccineOrProphylaxis: Codable {
    
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
