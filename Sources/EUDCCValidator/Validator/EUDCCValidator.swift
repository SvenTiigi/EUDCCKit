import EUDCC
import Foundation

// MARK: - EUDCCValidator

/// An EUDCC Validator
public struct EUDCCValidator {
    
    /// Creates a new instance of `EUDCCValidator`
    public init() {}
    
}

// MARK: - ValidationResult

public extension EUDCCValidator {
    
    /// The ValidationResult
    typealias ValidationResult = Result<Void, Failure>
    
}

// MARK: - Failure

public extension EUDCCValidator {
    
    /// An EUDCCValidator Failure
    struct Failure: LocalizedError {
        
        // MARK: Properties
        
        /// The unsatisfied ValidationRule
        public let unsatisfiedRule: EUDCC.ValidationRule
        
        /// The failure reason
        public var failureReason: String? {
            self.unsatisfiedRule.tag.name
        }
        
        // MARK: Initializer
        
        /// Creates a new instance of `EUDCCValidator.Failure`
        /// - Parameter unsatisfiedRule: The unsatisfied ValidationRule
        public init(
            unsatisfiedRule: EUDCC.ValidationRule
        ) {
            self.unsatisfiedRule = unsatisfiedRule
        }
        
    }
    
}

// MARK: - Default ValidationRule

public extension EUDCCValidator {
    
    /// The EUDCC default ValidationRule
    static var defaultValidationRule: EUDCC.ValidationRule {
        .if(.isVaccination, then: .isFullyImmunized())
            || .if(.isTest, then: .isTestedNegative && .isTestValid())
            || .if(.isRecovery, then: .isRecoveryValid)
    }
    
}

// MARK: - Validate

public extension EUDCCValidator {
    
    /// Validate an `EUDCC` using a `ValidationRule`
    /// - Parameters:
    ///   - eudcc: The EUDCC that should be validated
    ///   - rule: The ValidationRule that should be used to validate the EUDCC. Default value `Self.defaultValidationRule`
    /// - Returns: The
    func validate(
        eudcc: EUDCC,
        rule: EUDCC.ValidationRule = Self.defaultValidationRule
    ) -> Result<Void, Failure> {
        // Verify ValidationRule satisfies
        guard rule(eudcc) else {
            // Otherwise return failure with unsatisfied ValidationRule
            return .failure(.init(unsatisfiedRule: rule))
        }
        // Return success as ValidationRule succeeded
        return .success(())
    }
    
}
