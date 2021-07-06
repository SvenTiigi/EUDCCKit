import EUDCC
import Foundation

// MARK: - EUDCCSignerCertificateService

/// An EUDCC SignerCertificate Service
public protocol EUDCCSignerCertificateService {
    
    /// Retrieve SignerCertificates
    /// - Parameter completion: The completion closure
    func getCertificates(
        completion: @escaping (Result<[EUDCC.SignerCertificate], Error>) -> Void
    )
    
}
