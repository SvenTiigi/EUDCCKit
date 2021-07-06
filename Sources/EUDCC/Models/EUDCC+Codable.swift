import Foundation

// MARK: - CodingKeys

private extension EUDCC {
    
    /// The Top-Level CodingKeys
    enum TopLevelCodingKeys: String, CodingKey {
        case issuer = "1"
        case issuedAt = "6"
        case expiresAt = "4"
        case eudcc = "-260"
    }
    
    /// The EUDCC Version CodingKeys
    enum EUDCCVersionCodingKeys: String, CodingKey {
        case v1 = "1"
    }
    
    /// The EUDCC CodingKeys
    enum EUDCCCodingKeys: String, CodingKey {
        case version = "ver"
        case dateOfBirth = "dob"
        case name = "nam"
        case vaccinations = "v"
        case tests = "t"
        case recoveries = "r"
        case cryptographicSignature = "cryptographicSignature"
        case base45Representation = "base45Representation"
    }
    
}

// MARK: - Decodable

extension EUDCC: Decodable {
    
    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let topLevelContainer = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        self.issuer = try topLevelContainer.decode(String.self, forKey: .issuer)
        self.issuedAt = try topLevelContainer.decode(
            forKey: .issuedAt,
            using: EUDCCTimestampFormatter.default
        )
        self.expiresAt = try topLevelContainer.decode(
            forKey: .expiresAt,
            using: EUDCCTimestampFormatter.default
        )
        let eudccContainer = try topLevelContainer
            .nestedContainer(keyedBy: EUDCCVersionCodingKeys.self, forKey: .eudcc)
            .nestedContainer(keyedBy: EUDCCCodingKeys.self, forKey: .v1)
        self.version = try eudccContainer.decode(
            String.self,
            forKey: .version
        )
        self.dateOfBirth = try eudccContainer.decode(
            forKey: .dateOfBirth,
            using: EUDCCDateFormatter.default
        )
        self.name = try eudccContainer.decode(
            Name.self,
            forKey: .name
        )
        if let vaccinations = try? eudccContainer.decode([EUDCC.Vaccination].self, forKey: .vaccinations),
           let vaccination = vaccinations.first {
            self.content = .vaccination(vaccination)
        } else if let tests = try? eudccContainer.decode([EUDCC.Test].self, forKey: .tests),
                  let test = tests.first {
            self.content = .test(test)
        } else if let recoveries = try? eudccContainer.decode([EUDCC.Recovery].self, forKey: .recoveries),
                  let recovery = recoveries.first {
            self.content = .recovery(recovery)
        } else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: eudccContainer.codingPath,
                    debugDescription: "EUDCC Content missing"
                )
            )
        }
        if let cryptographicSignature = try? eudccContainer.decodeIfPresent(
            CryptographicSignature.self,
            forKey: .cryptographicSignature
        ) {
            self.cryptographicSignature = cryptographicSignature
        } else {
            self.cryptographicSignature = .init(
                protected: .init(),
                unprotected: .init(),
                payload: .init(),
                signature: .init()
            )
        }
        if let base45Representation = try? eudccContainer.decode(String.self, forKey: .base45Representation) {
            self.base45Representation = base45Representation
        } else {
            self.base45Representation = .init()
        }
    }
    
}

// MARK: - EncoderUserInfoKeys

public extension EUDCC {
    
    /// The EUDCC Encoder UserInfo Keys
    enum EncoderUserInfoKeys {
        
        /// Skip Cryptographic Signature encoding CodingUserInfoKey
        static var skipCryptographicSignature: CodingUserInfoKey {
            .init(rawValue: "skip-cryptographic-signature")!
        }
        
        /// Skip Base-45 Representation  encoding CodingUserInfoKey
        static var skipBase45Representation: CodingUserInfoKey {
            .init(rawValue: "skip-base-45-representation")!
        }
        
    }
    
}

// MARK: - Encodable

extension EUDCC: Encodable {
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var topLevelContainer = encoder.container(keyedBy: TopLevelCodingKeys.self)
        try topLevelContainer.encode(self.issuer, forKey: .issuer)
        try topLevelContainer.encode(self.issuedAt, forKey: .issuedAt, using: EUDCCTimestampFormatter.default)
        try topLevelContainer.encode(self.expiresAt, forKey: .expiresAt, using: EUDCCTimestampFormatter.default)
        var eudccVersionContainer = topLevelContainer.nestedContainer(keyedBy: EUDCCVersionCodingKeys.self, forKey: .eudcc)
        var eudccContainer = eudccVersionContainer.nestedContainer(keyedBy: EUDCCCodingKeys.self, forKey: .v1)
        try eudccContainer.encode(self.version, forKey: .version)
        try eudccContainer.encode(self.dateOfBirth, forKey: .dateOfBirth, using: EUDCCDateFormatter.default)
        try eudccContainer.encode(self.name, forKey: .name)
        switch self.content {
        case .vaccination(let vaccination):
            try eudccContainer.encode([vaccination], forKey: .vaccinations)
        case .test(let test):
            try eudccContainer.encode([test], forKey: .tests)
        case .recovery(let recovery):
            try eudccContainer.encode([recovery], forKey: .recoveries)
        }
        if !(encoder.userInfo[EncoderUserInfoKeys.skipCryptographicSignature] as? Bool == true) {
            try eudccContainer.encode(self.cryptographicSignature, forKey: .cryptographicSignature)
        }
        if !(encoder.userInfo[EncoderUserInfoKeys.skipBase45Representation] as? Bool == true) {
            try eudccContainer.encode(self.base45Representation, forKey: .base45Representation)
        }
    }
    
}
