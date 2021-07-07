import EUDCC
import Foundation

// MARK: - EUDCCTrustService

/// An EUDCC TrustService
public protocol EUDCCTrustService {
    
    /// Retrieve EUDCC TrustCertificate
    /// - Parameter completion: The completion closure
    func getTrustCertificates(
        completion: @escaping (Result<[EUDCC.TrustCertificate], Error>) -> Void
    )
    
}
