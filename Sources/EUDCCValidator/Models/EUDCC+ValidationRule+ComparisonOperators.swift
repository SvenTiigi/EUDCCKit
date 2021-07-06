import EUDCC
import Foundation

// MARK: - ValidationRule+Equal

public extension EUDCC.ValidationRule {
    
    /// Returns a ValidationRule where two given ValidationRules results will be compared to equality
    /// - Parameters:
    ///   - lhs: The left-hand side of the operation
    ///   - rhs: The right-hand side of the operation
    static func == (
        lhs: Self,
        rhs: Self
    ) -> Self {
        .init(tag: "\(lhs.tag) EQUALS \(rhs.tag)") { eudcc in
            lhs(eudcc) == rhs(eudcc)
        }
    }
    
}

// MARK: - ValidationRule+Unequal

public extension EUDCC.ValidationRule {
    
    /// Returns a ValidationRule where two given ValidationRule results will be compared to unequality
    /// - Parameters:
    ///   - lhs: The left-hand side of the operation
    ///   - rhs: The right-hand side of the operation
    static func != (
        lhs: Self,
        rhs: Self
    ) -> Self {
        .init(tag: "\(lhs.tag) NOT-EQUALS \(rhs.tag)") { eudcc in
            lhs(eudcc) == rhs(eudcc)
        }
    }
    
}
