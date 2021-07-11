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
    
}

// MARK: - CompareAgainst+value(for:)

public extension EUDCC.ValidationRule.CompareAgainst {
    
    /// Retrieve CompareAgainst Value for an given EUDCC
    /// - Parameter eudcc: The EUDCC
    /// - Returns: The Valuze
    func value(
        for eudcc: EUDCC
    ) -> Value {
        switch self {
        case .constant(let value):
            return value
        case .keyPath(let keyPath):
            return eudcc[keyPath: keyPath]
        }
    }
    
}

// MARK: - ValidationRule+Compare

public extension EUDCC.ValidationRule {
    
    /// Compare value of a given KeyPath to another value using an operator
    /// - Parameters:
    ///   - keyPath: The KeyPath to the value of the EUDCC
    ///   - compareAgainstValue: The value to compare against
    ///   - operator: The operator used for comparison
    ///   - tag: The Tag. Default value `.init()`
    /// - Returns: A ValidationRule
    static func compare<Value>(
        value: CompareAgainst<Value>,
        to compareAgainstValue: CompareAgainst<Value>,
        operator: @escaping (Value, Value) -> Bool,
        tag: Tag = .init()
    ) -> Self {
        .init(tag: tag) { eudcc in
            `operator`(
                value.value(for: eudcc),
                compareAgainstValue.value(for: eudcc)
            )
        }
    }

}

// MARK: - ValidationRule+CompareDate

public extension EUDCC.ValidationRule {
    
    /// The CompareAgainstDate Parameter
    struct CompareAgainstDate {
        
        // MARK: Static-Properties
        
        /// The current Date CompareAgainstDate
        public static let currentDate: Self = .init(
            .constant(.init())
        )
        
        // MARK: Typealias
        
        /// The Date Adding typealias representing a Tuple with Calendar Component and Value
        public typealias Adding = (component: Calendar.Component, value: Int)
        
        // MARK: Properties
        
        /// The CompareAgainst Date
        public let compareAgainst: CompareAgainst<Date?>
        
        /// The optional Adding closure which takes in an EUDCC
        public let adding: ((EUDCC) -> Adding?)?
        
        // MARK: Initializer
        
        /// Creates a new instance of `CompareAgainstDate`
        /// - Parameters:
        ///   - compareAgainst: The CompareAgainst Date
        ///   - adding: The Adding closure which takes in an EUDCC
        public init(
            _ compareAgainst: CompareAgainst<Date?>,
            adding: @escaping (EUDCC) -> Adding?
        ) {
            self.compareAgainst = compareAgainst
            self.adding = adding
        }
        
        /// Creates a new instance of `CompareAgainstDate` which takes in an optional constant `Adding` value
        /// - Parameters:
        ///   - compareAgainst: The CompareAgainst Date
        ///   - adding: The optional Adding value. Default value `nil`
        public init(
            _ compareAgainst: CompareAgainst<Date?>,
            adding: Adding? = nil
        ) {
            self.compareAgainst = compareAgainst
            self.adding = adding.flatMap { adding in { _ in adding } }
        }
        
    }
    
    /// Compare two Dates using a given operator
    /// - Parameters:
    ///   - lhsDate: The left-hand-side CompareAgainstDate
    ///   - rhsDate: The right-hand-side CompareAgainstDate
    ///   - operator: The operator closure
    ///   - calendar: The Calendar. Default value `.current`
    ///   - tag: The Tag. Default value `.init()`
    static func compare(
        lhsDate: CompareAgainstDate,
        rhsDate: CompareAgainstDate,
        operator: @escaping (Date, Date) -> Bool,
        using calendar: Calendar = .current,
        tag: Tag = .init()
    ) -> Self {
        .init(tag: tag) { eudcc in
            // Verify LHS and RHS Date values are available
            guard var lhsDateValue = lhsDate.compareAgainst.value(for: eudcc),
                  var rhsDateValue = rhsDate.compareAgainst.value(for: eudcc) else {
                // Otherwise return false
                return false
            }
            // Check if LHS Date should be re-calculated
            if let lhsAddingClosure = lhsDate.adding {
                // Verify LHS Adding value is available
                guard let lhsAdding = lhsAddingClosure(eudcc) else {
                    // Otherwise return false
                    return false
                }
                // Verify updated LHS value for Adding is available
                guard let lhsUpdatedDateValue = calendar.date(
                    byAdding: lhsAdding.component,
                    value: lhsAdding.value,
                    to: lhsDateValue
                ) else {
                    // Otherwise return false
                    return false
                }
                // Update LHS Date value
                lhsDateValue = lhsUpdatedDateValue
            }
            // Check if RHS Date should be re-calculated
            if let rhsAddingClosure = rhsDate.adding {
                // Verify LHS Adding value is available
                guard let rhsAdding = rhsAddingClosure(eudcc) else {
                    // Otherwise return false
                    return false
                }
                // Verify updated RHS value for Adding is available
                guard let rhsUpdatedDateValue = calendar.date(
                    byAdding: rhsAdding.component,
                    value: rhsAdding.value,
                    to: rhsDateValue
                ) else {
                    // Otherwise return false
                    return false
                }
                // Update RHS Date value
                rhsDateValue = rhsUpdatedDateValue
            }
            // Return comparison result of operator
            return `operator`(lhsDateValue, rhsDateValue)
        }
    }
    
}
