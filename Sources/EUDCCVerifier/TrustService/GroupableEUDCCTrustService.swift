import EUDCC
import Foundation

// MARK: - GroupableEUDCCTrustService

/// A groupable EUDCCTrustService
public struct GroupableEUDCCTrustService {
    
    // MARK: Properties
    
    /// The array of EUDCCTrustServices
    let trustServices: [EUDCCTrustService]
    
    // MARK: Initializer
    
    /// Creates a new instance of `GroupEUDCCTrustService`
    /// - Parameter trustServices: An array of `EUDCCTrustService` elements
    public init(
        trustServices: [EUDCCTrustService]
    ) {
        self.trustServices = trustServices
    }
    
}

// MARK: - Failure

public extension GroupableEUDCCTrustService {
    
    /// The GroupableEUDCCTrustService Failure
    struct Failure: Error {
        
        // MARK: Properties
        
        /// The error reason
        public let reason: String
        
        /// The optional array of underlying Error objects
        public let underlyingErrors: [Error]?
        
        /// Creates a new instance of `GroupEUDCCTrustService.Failure`
        /// - Parameters:
        ///   - reason: The error reason
        ///   - underlyingErrors: The optional array of underlying Error objects. Default value `nil`
        public init(
            reason: String,
            underlyingErrors: [Error]? = nil
        ) {
            self.reason = reason
            self.underlyingErrors = underlyingErrors
        }
        
    }
    
}

// MARK: - EUDCCTrustService

extension GroupableEUDCCTrustService: EUDCCTrustService {
    
    /// Retrieve EUDCC TrustCertificates
    /// - Parameter completion: The completion closure
    public func getTrustCertificates(
        completion: @escaping (Result<[EUDCC.TrustCertificate], Error>) -> Void
    ) {
        // Verify TrustServices are not empty
        guard !self.trustServices.isEmpty else {
            // Otherwise complete with failure
            return completion(
                .failure(
                    Failure(reason: "No EUDCCTrustServices are available")
                )
            )
        }
        // Initialize array of results
        var results: [Result<[EUDCC.TrustCertificate], Error>] = .init()
        // Initialize a DispatchGroup
        let dispatchGroup = DispatchGroup()
        // Initializ a DispatchQueue
        let dispatchQueue = DispatchQueue(
            label: "de.tiigi.EUDCCKit.GroupEUDCCTrustService"
        )
        // For each TrustService
        for trustService in self.trustServices {
            // Enter the DispatchGroup
            dispatchGroup.enter()
            // Retrieve TrustCertificates
            trustService.getTrustCertificates { result in
                // Dispatch on DispatchQueue
                dispatchQueue.async {
                    // Append Result
                    results.append(result)
                    // Leave DispatchGroup
                    dispatchGroup.leave()
                }
            }
        }
        // DispatchGroup notify on main thread
        dispatchGroup.notify(
            queue: .main
        ) {
            // Map results to certificates
            let certificates = results
                .compactMap { try? $0.get() }
                .flatMap { $0 }
            // Verify Certificates are not empty
            guard certificates.isEmpty else {
                // Otherwise complete with failure
                return completion(
                    .failure(
                        Failure(
                            reason: "No TrustCertificates have been retrieved",
                            underlyingErrors: results
                                .compactMap { result in
                                    if case .failure(let error) = result {
                                        return error
                                    } else {
                                        return nil
                                    }
                                }
                        )
                    )
                )
            }
            // Complete with success
            completion(.success(certificates))
        }
    }
    
}
