import EUDCC
import Foundation

// MARK: - EUDCC Content ValidationRule

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

// MARK: - EUDCC is Vaccination complete

public extension EUDCC.ValidationRule {
    
    /// Has received all vaccination doses
    static var isVaccinationComplete: Self {
        isVaccination && .compare(
            value: \.vaccination?.doseNumber,
            to: .keyPath(\.vaccination?.totalSeriesOfDoses),
            operator: ==,
            tag: "vaccinationHasAllDoses"
        )
    }
    
}
