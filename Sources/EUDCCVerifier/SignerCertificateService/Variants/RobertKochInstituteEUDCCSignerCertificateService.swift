import EUDCC
import Foundation

// MARK: - RobertKochInstituteEUDCCSignerCertificateService

/// The Robert-Koch-Institute EUDCC SignerCertificate Service
public final class RobertKochInstituteEUDCCSignerCertificateService {
    
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

extension RobertKochInstituteEUDCCSignerCertificateService {
    
    /// The TrustList Response
    struct TrustList: Codable {
        
        /// The TrustCertificates
        let certificates: [TrustCertificate]
        
    }

    /// A TrustCertificate
    struct TrustCertificate: Codable {
        
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

public extension RobertKochInstituteEUDCCSignerCertificateService {
    
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

// MARK: - EUDCCSignerCertificateService

extension RobertKochInstituteEUDCCSignerCertificateService: EUDCCSignerCertificateService {
    
    /// Retrieve SignerCertificates
    /// - Parameter completion: The completion closure
    public func getCertificates(
        completion: @escaping (Result<[EUDCC.SignerCertificate], Error>) -> Void
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
            let trustList: TrustList
            do {
                // Try to decode TrustList
                trustList = try JSONDecoder().decode(
                    TrustList.self,
                    from: .init(responseComponents[1].utf8)
                )
            } catch {
                // On Error complete with failure
                return DispatchQueue.main.async {
                    completion(.failure(Failure.decodingError(error)))
                }
            }
            // Map TrustCertificates to SignerCertificates
            let signerCertificates: [EUDCC.SignerCertificate] = trustList
                .certificates
                .map { certificate in
                    .init(
                        keyID: .init(rawValue: certificate.kid),
                        contents: certificate.rawData
                    )
                }
            // Complete with success
            DispatchQueue.main.async {
                completion(.success(signerCertificates))
            }
        }
        // Execute Request
        dataTask.resume()
    }
    
}
