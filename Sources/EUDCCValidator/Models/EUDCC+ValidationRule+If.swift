import EUDCC
import Foundation

// MARK: - ValidationRule+if

public extension EUDCC.ValidationRule {
    
    /// Conditionally execute a ValidationRule
    /// - Parameters:
    ///   - condition: The ValidationRule that will be evaluated
    ///   - then: The then ValidationRule
    ///   - else: The optional ValidationRule
    static func `if`(
        _ condition: Self,
        then: Self,
        else: Self
    ) -> Self {
        .init(
            tag: """
            if \(condition.tag) {
                \(then.tag)
            } else {
                \(`else`.tag)
            }
            """
        ) { eudcc in
            condition(eudcc) ? then(eudcc) : `else`(eudcc)
        }
    }
    
}
