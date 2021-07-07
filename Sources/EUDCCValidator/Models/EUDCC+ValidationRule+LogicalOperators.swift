import EUDCC
import Foundation

// MARK: - ValidationRule+Not

public extension EUDCC.ValidationRule {
    
    /// Performs a logical `NOT` (`!`) operation on a ValidationRule
    /// - Parameter rule: The ValidationRule to negate
    static prefix func ! (
        rule: EUDCC.ValidationRule
    ) -> Self {
        .init(tag: "!(\(rule.tag))") { eudcc in
            !rule(eudcc)
        }
    }
    
}

// MARK: - ValidationRule+And

public extension EUDCC.ValidationRule {
    
    /// Performs a logical `AND` (`&&`) operation on two ValidationRules
    /// - Parameters:
    ///   - lhs: The left-hand side of the operation
    ///   - rhs: The right-hand side of the operation
    static func && (
        lhs: Self,
        rhs: Self
    ) -> Self {
        .init(tag: "\(lhs.tag) && \(rhs.tag)") { eudcc in
            lhs(eudcc) && rhs(eudcc)
        }
    }
    
}

// MARK: - ValidationRule+Or

public extension EUDCC.ValidationRule {
    
    /// Performs a logical `OR` (`||`) operation on two ValidationRules
    /// - Parameters:
    ///   - lhs: The left-hand side of the operation
    ///   - rhs: The right-hand side of the operation
    static func || (
        lhs: Self,
        rhs: Self
    ) -> Self {
        .init(tag: "\(lhs.tag) || \(rhs.tag)") { eudcc in
            lhs(eudcc) || rhs(eudcc)
        }
    }
    
}

