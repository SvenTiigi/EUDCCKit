import EUDCC
import Foundation

// MARK: - EUCentralEUDCCSignerCertificateService

/// The EU Central EUDCC SignerCertificate Service
public final class EUCentralEUDCCSignerCertificateService {
    
    // MARK: Properties
    
    /// The URL
    let url: URL
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameter url: The URL
    public init(
        url: URL = .init(string: "https://dgca-verifier-service-eu-acc.cfapps.eu10.hana.ondemand.com/signercertificateUpdate")!
    ) {
        self.url = url
    }
    
}

// MARK: - EUDCCSignerCertificateService

extension EUCentralEUDCCSignerCertificateService: EUDCCSignerCertificateService {
    
    /// Retrieve SignerCertificates
    /// - Parameter completion: The completion closure
    public func getCertificates(
        completion: @escaping (Result<[EUDCC.SignerCertificate], Error>) -> Void
    ) {
        // Fetch Certificates
        self.fetchCertificates { signerCertificates in
            // Dispatch on Main-Queue
            DispatchQueue.main.async {
                // Complete with success
                completion(.success(signerCertificates))
            }
        }
    }
    
}

// MARK: - Fetch Certificates

extension EUCentralEUDCCSignerCertificateService {
    
    /// Fetch Certificates recursively
    /// - Parameters:
    ///   - resumeToken: The current Resume-Token
    ///   - signerCertificates: The SignerCertificates
    ///   - completion: The completion closure
    func fetchCertificates(
        resumeToken: String? = nil,
        signerCertificates: [EUDCC.SignerCertificate] = .init(),
        completion: @escaping ([EUDCC.SignerCertificate]) -> Void
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
                // Otherwise complete with current SignerCertificates
                return completion(signerCertificates)
            }
            // Verify KeyID and Data is available
            guard let keyId = httpResponse.allHeaderFields["X-ID"] as? String,
                  let data = data else {
                // Otherwise complete with current SignerCertificates
                return completion(signerCertificates)
            }
            // Retrieve certificates contents as String from payload
            let certificateContents = String(decoding: data, as: UTF8.self)
            // Initialize SignerCertificate
            let signerCertificate = EUDCC.SignerCertificate(
                keyID: .init(rawValue: keyId),
                contents: certificateContents
            )
            // Append SignerCertificate to current SignerCertificates
            let signerCertificates = signerCertificates + [signerCertificate]
            // Verify the next ResumeToken is available
            guard let nextResumeToken = httpResponse.allHeaderFields["X-RESUME-TOKEN"] as? String else {
                // Otherwise complete with current SignerCertificates
                return completion(signerCertificates)
            }
            // Re-Fetch Certificates with next ResumeToken
            self?.fetchCertificates(
                resumeToken: nextResumeToken,
                signerCertificates: signerCertificates,
                completion: completion
            )
        }
        // Execute Request
        dataTask.resume()
    }
    
}
