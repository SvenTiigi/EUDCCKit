import EUDCC
import Foundation

// MARK: - ValidationRule

public extension EUDCC {
    
    /// An `EUDCC` ValidationRule
    struct ValidationRule {
        
        // MARK: Typealias
        
        /// The predicate typealias
        public typealias Predicate = (EUDCC) -> Bool
        
        // MARK: Properties
        
        /// The Tag
        public let tag: Tag
        
        /// The predicate
        let predicate: Predicate
        
        // MARK: Initializer
        
        /// Creates a new instance of  `EUDCC.ValidationRule`
        /// - Parameters:
        ///   - tag: The  Tag. Default value `.init()`
        ///   - predicate: The predicate closure
        public init(
            tag: Tag = .init(),
            predicate: @escaping Predicate
        ) {
            self.tag = tag
            self.predicate = predicate
        }
        
        // MARK: Call-As-Function
        
        /// Call `ValidationRule` as function
        /// - Parameter eudcc: The EUDCC that should be validated
        /// - Returns: The Bool value representing the result
        func callAsFunction(
            _ eudcc: EUDCC
        ) -> Bool {
            self.predicate(eudcc)
        }
        
    }
    
}

// MARK: - Default

public extension EUDCC.ValidationRule {
    
    /// The default `EUDCC.ValidationRule`
    static var `default`: Self {
        .if(
            .isVaccination,
            then: .isFullyImmunized()
                && .isWellKnownVaccineMedicinalProduct
                && !.isVaccinationExpired(),
            else: .if(
                .isTest,
                then: .isTestedNegative && .isTestValid(),
                else: .if(
                    .isRecovery,
                    then: .isRecoveryValid,
                    else: .constant(false)
                )
            )
        )
    }
    
}

// MARK: - Equatable

extension EUDCC.ValidationRule: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.tag == rhs.tag
    }

}

// MARK: - Hashable

extension EUDCC.ValidationRule: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(self.tag)
    }
    
}
