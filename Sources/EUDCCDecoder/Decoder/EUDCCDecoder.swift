import EUDCC
import Foundation
import SwiftCBOR

// MARK: - EUDCCDecoder

/// A `EUDCC` Decoder
public struct EUDCCDecoder {
    
    // MARK: Properties
    
    /// The EUDCC Prefix
    private let eudccPrefix: String
    
    /// The EUDCC JSONDecoder
    private let eudccJSONDecoder: JSONDecoder
    
    // MARK: Initializer
    
    /// Creates a new instance of `EUDCCDecoder`
    /// - Parameters:
    ///   - eudccPrefix: The EUDCC Prefix. Default value `HC1:`
    ///   - eudccJSONDecoder: The EUDCC JSONDecoder. Default value `.init()`
    public init(
        eudccPrefix: String = "HC1:",
        eudccJSONDecoder: JSONDecoder = .init()
    ) {
        self.eudccPrefix = eudccPrefix
        self.eudccJSONDecoder = eudccJSONDecoder
    }
    
}

// MARK: - DecodingError

public extension EUDCCDecoder {
    
    /// The EUDCC DecodingError
    enum DecodingError: Error {
        /// Base45 decoding Error
        case base45DecodingError(Error)
        /// CBOR decoding Error
        case cborDecodingError(Error)
        /// Malformed CBOR Error
        case malformedCBORError(Data)
        /// CBOR Processing Error
        case cborProcessingError(CBORProcessingError)
        /// COSE Payload CBOR Decoding Error
        case coseCBORDecodingError(Error?)
        /// COSE Payload JSON Data Error
        case cosePayloadJSONDataError(Error?)
        /// EUDCC JSONDecoding Error
        case eudccJSONDecodingError(Error)
    }
    
    /// The CBORProcessingError
    enum CBORProcessingError: Error {
        /// Contents is missing
        case contentMissing
        /// Protected parameter is missing
        case protectedParameterMissing
        /// Unprotected paramter is missing
        case unprotectedParameterMissing
        /// Payload parameter is missing
        case payloadParameterMissing
        /// Signature parameter is missing
        case signatureParameterMissing
    }
    
}

// MARK: - Decode

public extension EUDCCDecoder {
    
    /// Decode EUDCC from EUDCC Base-45 encoded `Data`
    /// - Parameter base45EncodedData: The EUDCC Base-45 encoded `Data`
    /// - Returns: A Result contains either the successfully decoded EUDCC or an DecodingError
    func decode(
        from base45EncodedData: Data
    ) -> Result<EUDCC, DecodingError> {
        self.decode(
            from: .init(
                decoding: base45EncodedData,
                as: UTF8.self
            )
        )
    }
    
    /// Decode EUDCC from EUDCC Base-45 encoded `String`
    /// - Parameter base45EncodedString: The EUDCC Base-45 encoded `String`
    /// - Returns: A Result contains either the successfully decoded EUDCC or an DecodingError
    func decode(
        from base45EncodedString: String
    ) -> Result<EUDCC, DecodingError> {
        // Drop EUDCC Prefix
        self.dropPrefixIfNeeded(base45EncodedString)
            // Decode Base-45
            .flatMap(self.decodeBase45)
            // Decompress Data
            .flatMap(self.decompress)
            // Decode CBOR
            .flatMap(self.decodeCBOR)
            // Decode COSE
            .flatMap(self.decodeCOSE)
            // Decode EUDCC
            .flatMap(self.decodeEUDCC)
            // Set Base-45 Representation
            .map { eudcc in
                // Initialize mutable EUDCC
                var eudcc = eudcc
                // Set Base-45 Representation
                eudcc.mutate(
                    base45Representation: base45EncodedString
                )
                // Return updated EUDCC
                return eudcc
            }
    }
    
}

// MARK: - Drop Prefix if needed

private extension EUDCCDecoder {
    
    /// Drop `EUDCC` prefix if needed
    /// - Parameter input: The input String
    func dropPrefixIfNeeded(
        _ input: String
    ) -> Result<String, DecodingError> {
        // Initialize mutable input
        var input = input
        // Check if starts with EUDCC prefix
        if input.starts(with: self.eudccPrefix) {
            // Drop EUDCC prefix
            input = .init(
                input.dropFirst(self.eudccPrefix.count)
            )
        }
        // Return success with dropped EUDCC prefix
        return .success(input)
    }
    
}

// MARK: - Decode Base-45

private extension EUDCCDecoder {
    
    /// Decode a given String to a valid Base-45 Data object
    /// - Parameter input: The input String
    func decodeBase45(
        _ input: String
    ) -> Result<Data, DecodingError> {
        do {
            // Try to decode String to Base-45 Data
            return .success(try .init(base45Encoded: input))
        } catch {
            // Return Base45 Decoding Error
            return .failure(.base45DecodingError(error))
        }
    }
    
}

// MARK: - Decompress

private extension EUDCCDecoder {
    
    /// Decompress Data
    /// - Parameter input: The input Data object
    func decompress(
        _ input: Data
    ) -> Result<Data, DecodingError> {
        .success(input.decompressed())
    }
    
}

// MARK: - Decode CBOR

private extension EUDCCDecoder {
    
    /// Decode CBOR
    /// - Parameter input: The input Data object
    func decodeCBOR(
        _ input: Data
    ) -> Result<SwiftCBOR.CBOR, DecodingError> {
        // Initialize CBORDecoder
        let cborDecoder = SwiftCBOR.CBORDecoder(
            input: [UInt8](input)
        )
        do {
            // Try to decodeItem and verify CBOR is available
            guard let cbor = try cborDecoder.decodeItem() else {
                // Otherwise return malformed CBOR Error
                return .failure(.malformedCBORError(input))
            }
            // Return success with decoded CBOR
            return .success(cbor)
        } catch {
            // Return CBOR decoding Error
            return .failure(.cborDecodingError(error))
        }
    }
    
}

// MARK: - Decode COSE

private extension EUDCCDecoder {
    
    /// Decode COSE
    /// - Parameter input: The input CBOR
    func decodeCOSE(
        _ input: SwiftCBOR.CBOR
    ) -> Result<COSE, DecodingError> {
        // Verify Content is available
        guard case .tagged(_, let value) = input,
              case .array(let contents) = value else {
            return .failure(.cborProcessingError(.contentMissing))
        }
        // Verify protected parameter is available
        guard contents.indices.contains(0),
              case .byteString(let protected) = contents[0] else {
            return .failure(.cborProcessingError(.protectedParameterMissing))
        }
        // Verify unprotected parameter is available
        guard contents.indices.contains(1),
              case .map(let unprotected) = contents[1] else {
            return .failure(.cborProcessingError(.unprotectedParameterMissing))
        }
        // Verify payload paramter is available
        guard contents.indices.contains(2),
              case .byteString(let payload) = contents[2] else {
            return .failure(.cborProcessingError(.payloadParameterMissing))
        }
        // Verify signature parameter is available
        guard contents.indices.contains(3),
              case .byteString(let signature) = contents[3] else {
            return .failure(.cborProcessingError(.signatureParameterMissing))
        }
        // Return success with COSE
        return .success(.init(
            protected: protected,
            unprotected: unprotected,
            payload: payload,
            signature: signature
        ))
    }
    
}

// MARK: - Decode EUDCC

private extension EUDCCDecoder {
    
    /// Decode EUDCC
    /// - Parameter input: The input COSE
    func decodeEUDCC(
        _ input: COSE
    ) -> Result<EUDCC, DecodingError> {
        // Declare CBOR Payload
        let cborPayload: SwiftCBOR.CBOR
        do {
            // Try to decode COSE Payload as CBOR and verify Item is available
            guard let cbor = try SwiftCBOR.CBORDecoder(input: input.payload).decodeItem() else {
                // Otherwise return COSE Payload JSON Data Error
                return .failure(.coseCBORDecodingError(nil))
            }
            // Initialize CBOR Payload
            cborPayload = cbor
        } catch {
            // Return COSE Payload JSON Data Error
            return .failure(.coseCBORDecodingError(error))
        }
        // Verify Dictionary Representation from CBOR Payload is available
        guard let dictionaryRepresentation = cborPayload.dictionaryRepresentation() else {
            // Otherwise return COSE Payload JSON Data Error
            return .failure(.cosePayloadJSONDataError(nil))
        }
        // Declare Payload JSON Data
        let payloadJSONData: Data
        do {
            // Try to serialize Dictionary Representation as JSON Data
            payloadJSONData = try JSONSerialization.data(
                withJSONObject: dictionaryRepresentation
            )
        } catch {
            // Return COSE Payload JSON Data Error
            return .failure(.cosePayloadJSONDataError(error))
        }
        // Declare EUDCC
        var eudcc: EUDCC
        do {
            // Try to decode EUDCC
            eudcc = try self.eudccJSONDecoder.decode(
                EUDCC.self,
                from: payloadJSONData
            )
        } catch {
            // Return EUDCC JSONDecoding Error
            return .failure(.eudccJSONDecodingError(error))
        }
        // Mutate CryptographicSignature from COSE
        eudcc.mutate(
            cryptographicSignature: .init(
                protected: .init(input.protected),
                unprotected: .init(
                    uniqueKeysWithValues: input.unprotected.map { key, value in
                        (.init(key.encode()), .init(value.encode()))
                    }
                ),
                payload: .init(input.payload),
                signature: .init(input.signature)
            )
        )
        // Return success with decoded EUDCC
        return .success(eudcc)
    }
    
}

// MARK: - EUDCC+mutate

private extension EUDCC {
    
    /// Mutate Base-45 representation
    /// - Parameter base45Representation: The new Base-45 representation
    mutating func mutate(
        base45Representation: String
    ) {
        self = .init(
            issuer: self.issuer,
            issuedAt: self.issuedAt,
            expiresAt: self.expiresAt,
            schmemaVersion: self.schmemaVersion,
            dateOfBirth: self.dateOfBirth,
            name: self.name,
            content: self.content,
            cryptographicSignature: self.cryptographicSignature,
            base45Representation: base45Representation
        )
    }
    
    /// Mutate CryptographicSignature
    /// - Parameter cryptographicSignature: The new CryptographicSignature
    mutating func mutate(
        cryptographicSignature: EUDCC.CryptographicSignature
    ) {
        self = .init(
            issuer: self.issuer,
            issuedAt: self.issuedAt,
            expiresAt: self.expiresAt,
            schmemaVersion: self.schmemaVersion,
            dateOfBirth: self.dateOfBirth,
            name: self.name,
            content: self.content,
            cryptographicSignature: cryptographicSignature,
            base45Representation: self.base45Representation
        )
    }
    
}
