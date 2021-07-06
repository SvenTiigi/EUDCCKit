import Foundation

// MARK: - EUDCC

/// The European Digital COVID Certificate (EUCC)
public struct EUDCC: Hashable {
    
    // MARK: Properties
    
    /// The issuer
    public let issuer: String
    
    /// The issued at Date
    public let issuedAt: Date
    
    /// The expiry Date
    public let expiresAt: Date
    
    /// The version
    public let version: String
    
    /// The date of birth
    public let dateOfBirth: Date
    
    /// The Name
    public let name: Name
    
    /// The Content
    public let content: Content
    
    /// The CryptographicSignature
    public let cryptographicSignature: CryptographicSignature
    
    /// The Base-45 representation
    public let base45Representation: String
    
    // MARK: Initializer
    
    /// Creates a new instance of `EUDCC`
    /// - Parameters:
    ///   - issuer: The issuer
    ///   - issuedAt: The issued at Date
    ///   - expiresAt: The expiry Date
    ///   - version: The version
    ///   - dateOfBirth: The date of birth
    ///   - name: The Name
    ///   - content: The Content
    ///   - cryptographicSignature: The CryptographicSignature
    ///   - base45Representation: The The Base-45 representation
    public init(
        issuer: String,
        issuedAt: Date,
        expiresAt: Date,
        version: String,
        dateOfBirth: Date,
        name: Name,
        content: Content,
        cryptographicSignature: CryptographicSignature,
        base45Representation: String
    ) {
        self.issuer = issuer
        self.issuedAt = issuedAt
        self.expiresAt = expiresAt
        self.version = version
        self.dateOfBirth = dateOfBirth
        self.name = name
        self.content = content
        self.cryptographicSignature = cryptographicSignature
        self.base45Representation = base45Representation
    }
    
}

// MARK: Convenience Content Accessor

public extension EUDCC {
    
    /// The Vaccination case of the `Content` if available
    var vaccination: Vaccination? {
        if case .vaccination(let vaccination) = self.content {
            return vaccination
        } else {
            return nil
        }
    }
    
    /// The Test case of the `Content` if available
    var test: Test? {
        if case .test(let test) = self.content {
            return test
        } else {
            return nil
        }
    }
    
    /// The Recovery case of the `Content` if available
    var recovery: Recovery? {
        if case .recovery(let recovery) = self.content {
            return recovery
        } else {
            return nil
        }
    }
    
}
