import EUDCC
import Foundation

// MARK: - EUDCC+verify

public extension EUDCC {
    
    /// Verify `EUDCC` using an `EUDCCVerifier`
    /// - Parameters:
    ///   - verifier: The EUDCCVerifier
    ///   - completion: The verification completion closure
    func verify(
        using verifier: EUDCCVerifier,
        completion: @escaping (EUDCCVerifier.VerificationResult) -> Void
    ) {
        verifier.verify(
            eudcc: self,
            completion: completion
        )
    }
    
}
