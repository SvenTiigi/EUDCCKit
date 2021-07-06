import Foundation
import SwiftCBOR

// MARK: - CBOR+dictionaryRepresentation

extension SwiftCBOR.CBOR {
    
    /// Retrieve a Dictionary representation of the current CBOR object if available
    func dictionaryRepresentation() -> [String: Any?]? {
        // Verify CBOR is a map
        guard case .map(let cborMap) = self else {
            // Otherwise return nil
            return nil
        }
        // Convert CBOR Map to `Dictionary<String, Any?>`
        let dictionary = cborMap.convert()
        // Return nil if Dictionary is empty otherwise return the dictionary
        return dictionary.isEmpty ? nil : dictionary
    }
    
}

// MARK: - Dictionary<CBOR, CBOR>

private extension Dictionary where Key == CBOR, Value == CBOR {
    
    /// Convert the CBOR Dictionary to a `Dictionary<String, Any?>`
    func convert() -> [String: Any?] {
        // Initialize result Dictionary
        var dictionary: [String: Any?] = .init()
        // For each Key and Value CBOR
        for (key, value) in self {
            // Verify dictionary Key is available
            guard let key = key.dictionaryKey else {
                // Otherwise continue
                continue
            }
            // Update Value for Key
            dictionary.updateValue(value.dictionaryValue, forKey: key)
        }
        // Return converted Dictionary
        return dictionary
    }
    
}

// MARK: - CBOR+dictionaryKey

private extension SwiftCBOR.CBOR {
    
    /// The dictionary Key
    var dictionaryKey: String? {
        switch self {
        case .utf8String(let string):
            return string
        case .unsignedInt(let int):
            return .init(int)
        case .negativeInt(let int):
            return "-\(int + 1)"
        default:
            return nil
        }
    }
    
}

// MARK: - CBOR+dictionaryValue

private extension SwiftCBOR.CBOR {
    
    /// The dictionary Value
    var dictionaryValue: Any? {
        switch self {
        case .boolean(let boolValue):
            return boolValue as Any
        case .unsignedInt(let uIntValue):
            return Int(uIntValue) as Any
        case .negativeInt(let negativeIntValue):
            return -Int(negativeIntValue) - 1 as Any
        case .double(let doubleValue):
            return doubleValue as Any
        case .float(let floatValue):
            return floatValue as Any
        case .half(let halfValue):
            return halfValue as Any
        case .simple(let simpleValue):
            return simpleValue as Any
        case .byteString(let byteStringValue):
            return byteStringValue as Any
        case .date(let dateValue):
            return dateValue as Any
        case .utf8String(let stringValue):
            return stringValue as Any
        case .array(let arrayValue):
            return arrayValue.map(\.dictionaryValue)
        case .map(let mapValue):
            return mapValue.convert() as Any
        case .null, .undefined, .tagged, .break:
            return nil as Any?
        }
    }
    
}
