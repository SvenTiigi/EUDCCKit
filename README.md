<h1 align="center">EU Digital COVID Certificate Kit</h1>

<p align="center">
    A Swift Package to decode, verify and validate EU Digital COVID Certificates<br/>for iOS, tvOS, watchOS and macOS
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.4-orange.svg?style=flat" alt="Swift 5.4">
   </a>
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

## Disclaimer

> This is not an offical implementation of the EU Digital COVID Certificate

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

### EUDCCVerifier

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

### EUDCCValidator

The `EUDCCValidator` library provides an `EUDCCValidator` object which can be used to validate the EU Digital COVID Certifiate based on given rules.

```swift
import EUDCCValidator

// Initialize an EUDCCValidator
let validator = EUDCCValidator()

// Validate EU Digital COVID Certificate
let validationResult = validator.validate(
    eudcc: eudcc,
    rule: !(.isTest || .isRecovery) && .isVaccination && .hasAllVaccinationDoses
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

## Advanced

>tbd...

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