import EUDCC
import Foundation

// MARK: - Constant

public extension EUDCC.ValidationRule {
    
    /// Constant ValidationRule that will always return the given Bool result value
    /// - Parameter result: The Bool resul value
    static func constant(
        _ result: Bool
    ) -> Self {
        .init(tag: "\(result)") { _ in result }
    }
    
}

// MARK: - EUDCC Content Type

public extension EUDCC.ValidationRule {
    
    /// Has vaccination content ValidationRule
    static var isVaccination: Self {
        self.compare(
            value: .keyPath(\.vaccination),
            to: .constant(nil),
            operator: !=,
            tag: "isVaccination"
        )
    }
    
    /// Has test content ValidationRule
    static var isTest: Self {
        self.compare(
            value: .keyPath(\.test),
            to: .constant(nil),
            operator: !=,
            tag: "isTest"
        )
    }
    
    /// Has recover content ValidationRule
    static var isRecovery: Self {
        self.compare(
            value: .keyPath(\.recovery),
            to: .constant(nil),
            operator: !=,
            tag: "isRecovery"
        )
    }
    
}

// MARK: - EUDCC Vaccination

public extension EUDCC.ValidationRule {
    
    /// Has received all vaccination doses
    static var isVaccinationComplete: Self {
        .isVaccination
            && .compare(
                value: .keyPath(\.vaccination?.doseNumber),
                to: .keyPath(\.vaccination?.totalSeriesOfDoses),
                operator: ==,
                tag: "isVaccinationComplete"
            )
    }
    
    /// Vaccination can be considered as fully immunized
    /// - Parameters:
    ///   - minimumDaysPast: The amount of minimum days past since the last vaccination. Default value `15`
    ///   - calendar: The Calendar that should be used. Default value `.current`
    static func isFullyImmunized(
        minimumDaysPast: Int = 15,
        using calendar: Calendar = .current
    ) -> Self {
        .isVaccinationComplete
            && .compare(
                lhsDate: .currentDate,
                rhsDate: .init(
                    .keyPath(\.vaccination?.dateOfVaccination),
                    adding: (.day, minimumDaysPast)
                ),
                operator: >,
                using: calendar,
                tag: "isFullyImmunized-after-\(minimumDaysPast)-days"
            )
    }
    
    /// Validates if the vaccination expired by comparing if the current Date
    /// is greater than the date of vaccination added by the `maximumDaysSinceVaccinationDate`
    /// - Parameters:
    ///   - maximumDaysSinceVaccinationDate: The maximum days since date of vaccination. Default value `365`
    ///   - calendar: The Calendar. Default value `.current`
    static func isVaccinationExpired(
        maximumDaysSinceVaccinationDate: Int = 365,
        using calendar: Calendar = .current
    ) -> Self {
        .isVaccination
            && .compare(
                lhsDate: .currentDate,
                rhsDate: .init(
                    .keyPath(\.vaccination?.dateOfVaccination),
                    adding: (.hour, maximumDaysSinceVaccinationDate)
                ),
                operator: >,
                using: calendar,
                tag: "is-vaccination-expired-\(maximumDaysSinceVaccinationDate)-days"
            )
    }
    
    /// Validates if EUDCC contains a Vaccination and the `VaccineMedicinalProduct` value
    /// is contained in the  `WellKnownValue`enumeration
    static var isWellKnownVaccineMedicinalProduct: Self {
        .vaccineMedicinalProductIsOneOf(
            EUDCC.Vaccination.VaccineMedicinalProduct.WellKnownValue.allCases
        )
    }
    
    /// Validates if the `VaccineMedicinalProduct` is contained in the given Sequence of VaccineMedicinalProduct WellKnownValues
    /// - Parameter validVaccineMedicinalProducts: The VaccineMedicinalProduct WellKnownValue Sequence
    static func vaccineMedicinalProductIsOneOf<Vaccines: Sequence>(
        _ validVaccineMedicinalProducts: Vaccines
    ) -> Self where Vaccines.Element == EUDCC.Vaccination.VaccineMedicinalProduct.WellKnownValue {
        .isVaccination
            && .init(
                tag: "isVaccineMedicinalProduct-one-of-\(validVaccineMedicinalProducts)"
            ) { eudcc in
                // Verify WellKnownValue of VaccineMedicinalProduct is available
                guard let vaccineMedicinalProductWellKnownValue = eudcc.vaccination?.vaccineMedicinalProduct.wellKnownValue else {
                    // Otherwise return false
                    return false
                }
                // Return result if VaccineMedicinalProduct WellKnownValue is contained in the given Sequence
                return validVaccineMedicinalProducts.contains(vaccineMedicinalProductWellKnownValue)
            }
    }
    
}

// MARK: - EUDCC Test

public extension EUDCC.ValidationRule {
    
    /// TestResult of Test is positive
    static var isTestedPositive: Self {
        .isTest
            && .compare(
                value: .keyPath(\.test?.testResult.value),
                to: .constant(EUDCC.Test.TestResult.WellKnownValue.positive.rawValue),
                operator: ==,
                tag: "isTestedPositive"
            )
    }
    
    /// TestResult of Test is negative
    static var isTestedNegative: Self {
        .isTest
            && .compare(
                value: .keyPath(\.test?.testResult.value),
                to: .constant(EUDCC.Test.TestResult.WellKnownValue.negative.rawValue),
                operator: ==,
                tag: "isTestedNegative"
            )
    }
    
    /// Is Test valid
    /// - Parameters:
    ///   - maximumHoursPast: The maximum hours past since date of sample collection. Default value `PCR: 72 | RAPID: 48`
    ///   - calendar: The Calendar that should be used. Default value `.current`
    static func isTestValid(
        maximumHoursPast: @escaping (EUDCC.Test.TestType.WellKnownValue) -> Int = { $0 == .pcr ? 72 : 48 },
        using calendar: Calendar = .current
    ) -> Self {
        .isTest
            && .compare(
                lhsDate: .currentDate,
                rhsDate: .init(
                    .keyPath(\.test?.dateOfSampleCollection),
                    adding: { eudcc in
                        // Verify TestType WellKnownValue is available
                        guard let testTypeWellKnownValue = eudcc.test?.typeOfTest.wellKnownValue else {
                            // Otherwise return nil
                            return nil
                        }
                        // Return adding hour with maximum hours past for TestType WellKnownValue
                        return (.hour, maximumHoursPast(testTypeWellKnownValue))
                    }
                ),
                operator: <=,
                using: calendar,
                tag: "isTestValid"
            )
    }
    
}

// MARK: - EUDCC Recovery

public extension EUDCC.ValidationRule {
    
    /// Is Recovery valid
    static var isRecoveryValid: Self {
        .isRecovery
            && .init(tag: "isRecoveryValid") { eudcc in
                // Verify Recovery is available
                guard let recovery = eudcc.recovery else {
                    // Otherwise return false
                    return false
                }
                // Initialize valid Date Range
                let validDateRange = recovery.certificateValidFrom...recovery.certificateValidUntil
                // Return Bool value if current Date is contained in valid Date Range
                return validDateRange.contains(.init())
            }
    }
    
}
