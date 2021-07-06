import EUDCC
import Foundation

// MARK: - EUDCC Content Type

public extension EUDCC.ValidationRule {
    
    /// Has vaccination content ValidationRule
    static var isVaccination: Self {
        self.compare(
            value: \.vaccination,
            to: .constant(nil),
            operator: !=,
            tag: "isVaccination"
        )
    }
    
    /// Has test content ValidationRule
    static var isTest: Self {
        self.compare(
            value: \.test,
            to: .constant(nil),
            operator: !=,
            tag: "isTest"
        )
    }
    
    /// Has recover content ValidationRule
    static var isRecovery: Self {
        self.compare(
            value: \.recovery,
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
                value: \.vaccination?.doseNumber,
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
            && .init(
                tag: "isFullyImmunized-after-\(minimumDaysPast)-days"
            ) { eudcc in
                // Verify Vaccination is available
                guard let vaccination = eudcc.vaccination else {
                    // Otherwise return false
                    return false
                }
                // Verify fully immunized Date is available from calendar
                guard let fullyImmunizedDate = calendar.date(
                    byAdding: .day,
                    value: minimumDaysPast,
                    to: vaccination.dateOfVaccination
                ) else {
                    // Otherwise return false
                    return false
                }
                // Current Date must be greater than the fully immunized Date
                return Date() > fullyImmunizedDate
            }
    }
    
}


// MARK: - EUDCC Test

public extension EUDCC.ValidationRule {
    
    /// TestResult of Test is positive
    static var isTestedPositive: Self {
        .isTest
            && .compare(
                value: \.test?.testResult.value,
                to: .constant(EUDCC.Test.TestResult.WellKnownValue.positive.rawValue),
                operator: ==,
                tag: "isTestedPositive"
            )
    }
    
    /// TestResult of Test is negative
    static var isTestedNegative: Self {
        .isTest
            && .compare(
                value: \.test?.testResult.value,
                to: .constant(EUDCC.Test.TestResult.WellKnownValue.negative.rawValue),
                operator: ==,
                tag: "isTestedNegative"
            )
    }
    
}
