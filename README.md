<br/>
<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/EUDCCKit/gh-pages/readme-assets/logo.png" width="30%" alt="logo">
</p>

<h1 align="center">EU Digital COVID Certificate Kit</h1>

<p align="center">
    A Swift Package to decode, verify and validate EU Digital COVID Certificates<br/>for iOS, tvOS, watchOS and macOS
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.4-orange.svg?style=flat" alt="Swift 5.4">
   </a>
    <a href="https://sventiigi.github.io/EUDCCKit">
      <img src="https://github.com/SvenTiigi/EUDCCKit/blob/gh-pages/badge.svg" alt="Documentation">
   </a>
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

## Disclaimer

> The EUDCCKit is not an offical implementation of the EU Digital COVID Certificate

## Features

- [x] Easily decode an EU Digital COVID Certificate 🧾
- [x] Verify cryptographic signature 🔐
- [x] Certificate validation ✅

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/SvenTiigi/EUDCCKit.git", from: "0.0.1")
]
```

Or navigate to your Xcode project then select `Swift Packages`, click the “+” icon and search for `EUDCCKit`.

## Usage

The `EUDCCKit` Swift Package is made of four distinct libraries to decode, verify and validate an EU Digital COVID Certificate.

### EUDCC

The `EUDCC` library contains the model definition of the EU Digital COVID Certificate

```swift
import EUDCC

// The EU Digital COVID Certificate model
let eudcc: EUDCC

// Access content of EUDCC
switch eudcc.content {
case .vaccination(let vaccination):
    print("Vaccination", vaccination)
case .test(let test):
    print("Test", test)
case .recovery(let recovery):
    print("Recovery", recovery)
}
```

> Head over to the [advanced section](https://github.com/SvenTiigi/EUDCCKit#eudcc-1) to learn more.

### EUDDCDecoder

The `EUDCCDecoder` library provides an `EUDCCDecoder` object which is capabale of decoding a Base-45 string reperesentation of the EU Digital COVID Certificate which is mostly embedded in a QR-Code.

```swift
import EUDCCDecoder

// Initialize an EUDCCDecoder
let decoder = EUDCCDecoder()

// The Base-45 encoded EU Digital COVID Certificate from a QR-Code
let qrCodeContent = "HC1:..."

// Decode EUDCC from QR-Code
let decodingResult = decoder.decode(from: qrCodeContent)

// Switch on decoding result
switch decodingResult {
case .success(let eudcc):
    // Successfully decoded Digital COVID Certificate
    print("EU Digital COVID Certificate", eudcc)
case .failure(let decodingError):
    // Decoding failed with error
    print("Failed to decode EUDCC", decodingError)
}
```

> Head over to the [advanced section](https://github.com/SvenTiigi/EUDCCKit#euddcdecoder-1) to learn more.

### EUDCCVerifier

The `EUDCCVerifier` library provides an `EUDCCVerifier` object which can be used to verify the cryptographic signature of the EU Digital COVID Certificate.

```swift
import EUDCCVerifier

// Initialize an EUDDCCVerifier
let verifier = EUDCCVerifier(
    trustService: EUCentralEUDCCTrustService()
)

// Verify EU Digital COVID Certificate
verifier.verify(eudcc: eudcc) { verificationResult in
    // Switch on verification result
    switch verificationResult {
    case .success(let trustCertificate):
        print("Cryptographically valid", trustCertificate)
    case .invald:
        print("Invalid EUDCC")
    case .failure(let error):
        print("Error occured during verification", error)
    }
}
```

> Head over to the [advanced section](https://github.com/SvenTiigi/EUDCCKit#eudccverifier-1) to learn more.

### EUDCCValidator

The `EUDCCValidator` library provides an `EUDCCValidator` object which can be used to validate the EU Digital COVID Certifiate based on given rules.

```swift
import EUDCCValidator

// Initialize an EUDCCValidator
let validator = EUDCCValidator()

// Validate EU Digital COVID Certificate
let validationResult = validator.validate(
    eudcc: eudcc,
    rule: .isFullyImmunized() && !.isVaccinationExpired()
)

// Switch on validation result
switch validationResult {
case .success:
    // Successfully validated EU Digital COVID Certificate
    print("Successfully validated")
case .failure(let validationError):
    // Validation failure
    print("Validation failed", validationError)
}
```

> Head over to the [advanced section](https://github.com/SvenTiigi/EUDCCKit#eudccvalidator-1) to learn more.

## Advanced

### EUDCC

#### Content

Beside the `content` property of an `EUDCC` you can make use of the following convenience properties to check if the `EUDCC` contains a vaccination, test or recovery object.

```swift
import EUDCC

// Vaccination
let vaccination: EUDCC.Vaccination? = eudcc.vaccination

// Test
let test: EUDCC.Test? = eudcc.test

// Recovery
let recovery: EUDCC.Recovery? = eudcc.recovery
```

#### Well-Known-Value

Each of the following objects are exposing a `WellKnownValue` enumeration which can be used to retrieve more detailed information about a certain value:

- `EUDCC.DiseaseAgentTargeted`
- `EUDCC.Test.TestResult`
- `EUDCC.Test.TestType`
- `EUDCC.Vaccination.VaccineMarketingAuthorizationHolder`
- `EUDCC.Vaccination.VaccineMedicinalProduct`
- `EUDCC.Vaccination.VaccineOrProphylaxis`

```swift
import EUDCC

let vaccineMedicinalProduct: EUDCC.Vaccination.VaccineMedicinalProduct

// Switch on WellKnownValue of VaccineMedicinalProduct
switch vaccineMedicinalProduct.wellKnownValue {
    case .covid19VaccineModerna:
        break
    case .vaxzevria:
        break
    default:
        break
}
```

#### Encoding

The `EUDCC` contains two properties `cryptographicSignature` and `base45Representation` which are convenience objects that are not an offical part of the EU Digital COVID Certificate JSON Schema. 

If you wish to skip those properties when encoding an `EUDCC` you can set the following `userInfo` configuration to a `JSONEncoder`.

```swift
import EUDCC

let encoder = JSONEncoder()

encoder.userInfo = [
    // Skip encoding CryptographicSignature
    EUDCC.EncoderUserInfoKeys.skipCryptographicSignature: true,
    // Skip encoding Base-45 representation
    EUDCC.EncoderUserInfoKeys.skipBase45Representation: true,
]

let jsonData = try encoder.encode(eudcc)
```

### EUDDCDecoder

#### Decoding

The `EUDCCDecoder` supports decoding a Base-45 encoded `String` and `Data` object.

```swift
import EUDCCDecoder

let eudccDecoder = EUDCCDecoder()

// Decode from Base-45 encoded String
let eudccBase45EncodedString: String
let stringDecodingResult = eudccDecoder.decode(
    from: eudccBase45EncodedString
)

// Decode from Base-45 encoded Data
let eudccBase45EncodedData: Data
let dataDecodingResult = eudccDecoder.decode(
    from: eudccBase45EncodedData
)
```

#### Convenience decoding

By importing the `EUDCCDecoder` library the `EUDCC` object will be extended with a static `decode` function.

```swift
import EUDCCDecoder

let decodingResult = EUDCC.decode(from: "HC1:...")
```

### EUDCCVerifier

#### EUDCCTrustService

In order to verify an `EUDCC` the `EUDCCVerifier` needs to be instantiated with an instance of an `EUDCCTrustService` which is used to retrieve the trust certificates.

```swift
import EUDCC
import EUDCCVerifier

struct SpecificEUDCCTrustService: EUDCCTrustService {
    
    /// Retrieve EUDCC TrustCertificates
    /// - Parameter completion: The completion closure
    func getTrustCertificates(
        completion: @escaping (Result<[EUDCC.TrustCertificate], Error>) -> Void
    ) {
        // TODO: Retrieve TrustCertificates and invoke completion handler
    }
    
}

let eudccVerifier = EUDCCVerifier(
    trustService: SpecificEUDCCTrustService()
)
```

The `EUDCCKit` comes along with two pre defined `EUDCCTrustService` implementations:

- `EUCentralEUDCCTrustService`
- `RobertKochInstituteEUDCCTrustService`

#### Convenience verification

By importing the `EUDCCVerifier` library the `EUDCC` object will be extended with a `verify` function.

```swift
import EUDCC
import EUDCCVerifier

let eudcc: EUDCC

eudcc.verify(
    using: EUDCCVerifier(
        trustService: EUCentralEUDCCTrustService()
    )
) { verificationResult in
    switch verificationResult {
    case .success(let trustCertificate):
        break
    case .invald:
        break
    case .failure(let error):
        break
    }
}
```

### EUDCCValidator

#### ValidationRule

An `EUDCC` can be validated by using an `EUDCCValidator` and a given `EUDCC.ValidationRule`. An `EUDCC.ValidationRule` can be initialized with a simple closure wich takes in an `EUDCC` and returns a `Bool` whether the validation succeed or failed.

```swift
import EUDCC
import EUDCCValidator

// Simple EUDCC ValidationRule instantiation
let validationRule = EUDCC.ValidationRule { eudcc in
    // Process EUDCC and return Bool result
}

// EUDCC ValidationRule with Tag in order to uniquely identify a ValidationRule
let isVaccinationComplete = EUDCC.ValidationRule(
    tag: "is-vaccination-complete"
) { eudcc in
    eudcc.vaccination?.doseNumber == eudcc.vaccination?.totalSeriesOfDoses
}
```

The `EUDCCKit` comes along with many pre defined `EUDCC.ValidationRule` like the following ones.

```swift
import EUDCC
import EUDCCValidator

let eudcc: EUDCC
let validator = EUDCCValidator()

// Is fully immunized
validator.validate(
    eudcc: eudcc, 
    rule: .isFullyImmunized(minimumDaysPast: 15)
)

// Is tested positive
validator.validate(
    eudcc: eudcc, 
    rule: .isTestedPositive
)
```

#### Logical/Conditional operators

In order to create more complex rules each `EUDCC.ValidationRule` can be chained together by applying standard operators.

```swift
import EUDCC
import EUDCCValidator

let defaultValidationRule: EUDCC.ValidationRule = .if(
    .isVaccination,
    then: .isFullyImmunized() && .isWellKnownVaccineMedicinalProduct && !.isVaccinationExpired(),
    else: .if(
        .isTest,
        then: .isTestedNegative && .isTestValid(),
        else: .if(
            .isRecovery,
            then: .isRecoveryValid,
            else: .constant(false)
        )
    )
)
```

#### Convenience validation

By importing the `EUDCCValidator` library the `EUDCC` object will be extended with a `validate` function.

```swift
import EUDCC
import EUDCCValidator

let eudcc: EUDCC

let validationRule = eudcc.validate(
    rule: .isWellKnownVaccineMedicinalProduct
)
```

## License

```
EUDCCKit
Copyright (c) 2021 Sven Tiigi sven.tiigi@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
