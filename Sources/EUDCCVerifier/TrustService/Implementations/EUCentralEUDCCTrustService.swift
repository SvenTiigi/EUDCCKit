import EUDCC
import Foundation

// MARK: - EUCentralEUDCCTrustService

/// The EU Central EUDCC TrustService
public final class EUCentralEUDCCTrustService {
    
    // MARK: Properties
    
    /// The URL
    let url: URL
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameter url: The URL
    public init(
        url: URL = .init(string: "https://dgca-verifier-service.cfapps.eu10.hana.ondemand.com/signercertificateUpdate")!
    ) {
        self.url = url
    }
    
}

// MARK: - EUDCCTrustService

extension EUCentralEUDCCTrustService: EUDCCTrustService {
    
    /// Retrieve EUDCC TrustCertificates
    /// - Parameter completion: The completion closure
    public func getTrustCertificates(
        completion: @escaping (Result<[EUDCC.TrustCertificate], Error>) -> Void
    ) {
        // Fetch Certificates
        self.fetchCertificates { trustCertificates in
            // Dispatch on Main-Queue
            DispatchQueue.main.async {
                // Complete with success
                completion(.success(trustCertificates))
            }
        }
    }
    
}

// MARK: - Fetch Certificates

extension EUCentralEUDCCTrustService {
    
    /// Fetch Certificates recursively
    /// - Parameters:
    ///   - resumeToken: The current Resume-Token
    ///   - trustCertificates: The TrustCertificates
    ///   - completion: The completion closure
    func fetchCertificates(
        resumeToken: String? = nil,
        trustCertificates: [EUDCC.TrustCertificate] = .init(),
        completion: @escaping ([EUDCC.TrustCertificate]) -> Void
    ) {
        // Initialize URLRequest
        var urlRequest = URLRequest(url: self.url)
        // Check if a ResumeToken is available
        if let resumeToken = resumeToken {
            // Add ResumeToken
            urlRequest.setValue(
                resumeToken,
                forHTTPHeaderField: "X-RESUME-TOKEN"
            )
        }
        // Perform DataTask
        let dataTask = URLSession.shared.dataTask(
            with: urlRequest
        ) { [weak self] data, response, error in
            // Verify HTTPResponse is available and succeessfull
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                // Otherwise complete with current TrustCertificates
                return completion(trustCertificates)
            }
            // Verify KeyID and Data is available
            guard let keyId = httpResponse.allHeaderFields["x-kid"] as? String,
                  let data = data else {
                // Otherwise complete with current TrustCertificates
                return completion(trustCertificates)
            }
            // Retrieve certificates contents as String from payload
            let certificateContents = String(decoding: data, as: UTF8.self)
            // Initialize TrustCertificates
            let trustCertificate = EUDCC.TrustCertificate(
                keyID: .init(rawValue: keyId),
                contents: certificateContents
            )
            // Append TrustCertificate to current TrustCertificates
            let trustCertificates = trustCertificates + [trustCertificate]
            // Verify the next ResumeToken is available
            guard let nextResumeToken = httpResponse.allHeaderFields["x-resume-token"] as? String else {
                // Otherwise complete with current SignerCertificates
                return completion(trustCertificates)
            }
            // Re-Fetch Certificates with next ResumeToken
            self?.fetchCertificates(
                resumeToken: nextResumeToken,
                trustCertificates: trustCertificates,
                completion: completion
            )
        }
        // Execute Request
        dataTask.resume()
    }
    
}
