import EUDCC
import Foundation

// MARK: - RobertKochInstituteEUDCCTrustService

/// The Robert-Koch-Institute EUDCC TrustService
public final class RobertKochInstituteEUDCCTrustService {
    
    // MARK: Properties
    
    /// The URL
    let url: URL
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameter url: The URL
    public init(
        url: URL = .init(string: "https://de.dscg.ubirch.com/trustList/DSC/")!
    ) {
        self.url = url
    }
    
}

// MARK: - TrustList & TrustCertificate

extension RobertKochInstituteEUDCCTrustService {
    
    /// The TrustList Response
    struct RKITrustList: Codable {
        
        /// The TrustCertificates
        let certificates: [RKITrustCertificate]
        
    }

    /// A TrustCertificate
    struct RKITrustCertificate: Codable {
        
        /// The certificate type
        let certificateType: String
        
        /// The country
        let country: String
        
        /// The KeyID
        let kid: String
        
        /// The raw certificate data
        let rawData: String
        
        /// The signature
        let signature: String
        
        /// The tumbprint
        let thumbprint: String
        
        /// The timestamp
        let timestamp: String
        
    }
    
}

// MARK: - Failure

public extension RobertKochInstituteEUDCCTrustService {
    
    /// The Failure
    enum Failure: Error {
        /// Request errored
        case requestError(Error?)
        /// Certificates missing
        case certificatesMissing
        /// Decoding Error
        case decodingError(Error)
    }
    
}

// MARK: - EUDCCTrustService

extension RobertKochInstituteEUDCCTrustService: EUDCCTrustService {
    
    /// Retrieve EUDCC TrustCertificate
    /// - Parameter completion: The completion closure
    public func getTrustCertificates(
        completion: @escaping (Result<[EUDCC.TrustCertificate], Error>) -> Void
    ) {
        // Perform DataTask
        let dataTask = URLSession.shared.dataTask(
            with: self.url
        ) { data, response, error in
            // Verify Data is available
            guard let data = data else {
                // Complete with failure
                return DispatchQueue.main.async {
                    completion(.failure(Failure.requestError(error)))
                }
            }
            // Decode response body as String
            let response = String(decoding: data, as: UTF8.self)
            // Split response String
            let responseComponents = response.components(separatedBy: "\n")
            // Verify componets contains two items
            guard responseComponents.indices.contains(1) else {
                // Otherwise complete with falure
                return DispatchQueue.main.async {
                    completion(.failure(Failure.certificatesMissing))
                }
            }
            // Declare TrustList
            let trustList: RKITrustList
            do {
                // Try to decode TrustList
                trustList = try JSONDecoder().decode(
                    RKITrustList.self,
                    from: .init(responseComponents[1].utf8)
                )
            } catch {
                // On Error complete with failure
                return DispatchQueue.main.async {
                    completion(.failure(Failure.decodingError(error)))
                }
            }
            // Map TrustList to TrustCertificates
            let trustCertificates: [EUDCC.TrustCertificate] = trustList
                .certificates
                .map { certificate in
                    .init(
                        keyID: .init(rawValue: certificate.kid),
                        contents: certificate.rawData
                    )
                }
            // Complete with success
            DispatchQueue.main.async {
                completion(.success(trustCertificates))
            }
        }
        // Execute Request
        dataTask.resume()
    }
    
}
