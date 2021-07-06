import EUDCC
import Foundation

// MARK: - ValidationRule+CompareAgainst

public extension EUDCC.ValidationRule {
    
    /// The CompareAgainst enumeration
    enum CompareAgainst<Value> {
        /// Constant Value
        case constant(Value)
        /// Value retrieved from keyPath
        case keyPath(KeyPath<EUDCC, Value>)
    }
    
    /// Compare value of a given KeyPath to another value using an operator
    /// - Parameters:
    ///   - keyPath: The KeyPath to the value of the EUDCC
    ///   - compareAgainstValue: The value to compare against
    ///   - operator: The operator used for comparison
    ///   - tag: The Tag. Default value `.init()`
    /// - Returns: A ValidationRule
    static func compare<Value>(
        value keyPath: KeyPath<EUDCC, Value>,
        to compareAgainstValue: CompareAgainst<Value>,
        operator: @escaping (Value, Value) -> Bool,
        tag: Tag = .init()
    ) -> Self {
        .init(tag: tag) { eudcc in
            `operator`(
                eudcc[keyPath: keyPath],
                {
                    switch compareAgainstValue {
                    case .constant(let value):
                        return value
                    case .keyPath(let keyPath):
                        return eudcc[keyPath: keyPath]
                    }
                }()
            )
        }
    }

}
