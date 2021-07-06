<h1 align="center">EU Digital COVID Certificate Kit</h1>

<p align="center">
    A Swift Package to decode, verify and validate an EU Digital COVID Certificate for iOS, tvOS, watchOS and macOS
</p>

## Disclaimer

> This is not an offical implementation of the EU Digital COVID Certificate

## Usage

The `EUDCCKit` Swift Package bundelds up four distinct libraries.

### EUDCC

The `EUDCC` library contains the model definition of the EU Digital COVID Certificate

```swift
import EUDCC

// Acces to the core model definition 
let eudcc: EUDCC
```

### EUDDCDecoder

The `EUDCCDecoder` library provides an `EUDCCDecoder` object which is capabale of decoding an Base-45 string reperesentation of the EU Digital COVID Certificate which is mostly embedded in a QR-Code.

```swift
import EUDCCDecoder

// The contents of the scanned Digital COVID Certificate QR-Code
let covidCertificateQRCode = "HC1:..."

// Decode contents of QR-Code
let decodeResult = EUDCCDecoder().decode(from: covidCertificateQRCode)

// Switch on Result
switch decodeResult {
case .success(let eudcc):
    // Successfully decoded Digital COVID Certificate
    print("EU Digital COVID Certificate", eudcc)
case .failure(let decodingError):
    // Decoding failed with error
    print("Failed to decode EUDCC", decodingError)
}
```

### Verification

The `EUDCCVerifier` library provides an `EUDCCVerifier` object which can be used to verify the cryptographic signature of the EU Digital COVID Certificate.

```swift
import EUDCCVerifier

// Initialize an EUDDCCVerifier
let verifier = EUDCCVerifier(
    certificateService: EUCentralEUDCCSignerCertificateService()
)

// Verify EU Digital COVID Certificate
verifier.verify(eudcc: eudcc) { result in
    switch result {
    case .success(let signerCertificate):
        print("Cryptographically valid", signerCertificate)
    case .invald:
        print("Invalid EUDCC")
    case .failure(let error):
        print("Error occured during verification", error)
    }
}
```

### Validation

The `EUDCCValidator` library provides an `EUDCCValidator` object which can be used to validate the EU Digital COVID Certifiate based on given rules.

```swift
import EUDCCValidator

// Initialize an EUDCCValidator
let validator = EUDCCValidator()

// Validate EU Digital COVID Certificate
let validationResult = validator.validate(eudcc: eudcc)
```
