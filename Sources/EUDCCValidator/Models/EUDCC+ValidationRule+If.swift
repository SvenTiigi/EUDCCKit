import EUDCC
import Foundation

// MARK: - ValidationRule+if

public extension EUDCC.ValidationRule {
    
    /// Conditionally execute a ValidationRule
    /// - Parameters:
    ///   - condition: The ValidationRule that will be evaluated
    ///   - then: The then ValidationRule
    ///   - else: The optional ValidationRule. Default value `true`
    static func `if`(
        _ condition: Self,
        then: Self,
        else: Self = .init(tag: "true") { _ in true }
    ) -> Self {
        .init(
            tag: "if-\(condition.tag)-then-\(then.tag)-else-\(`else`.tag)"
        ) { eudcc in
            condition(eudcc) ? then(eudcc) : `else`(eudcc)
        }
    }
    
}
