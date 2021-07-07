import EUDCC
import Foundation

// MARK: - EUDCC+validate

public extension EUDCC {
    
    /// Valide `EUDCC` using a `ValidationRule`
    /// - Parameters:
    ///   - rule: The ValidationRule that hsould be used to value the EUDCC. Default value `.default`
    ///   - validator: The EUDCCValidator. Default value `.init()`
    /// - Returns: The ValidationResult
    func validate(
        rule: EUDCC.ValidationRule = .default,
        using validator: EUDCCValidator = .init()
    ) -> EUDCCValidator.ValidationResult {
        validator.validate(
            eudcc: self,
            rule: rule
        )
    }
    
}
