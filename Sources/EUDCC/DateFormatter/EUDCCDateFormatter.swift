import Foundation

// MARK: - EUDCCDateFormatter

/// The EUDCCDateFormatter
final class EUDCCDateFormatter: ISO8601DateFormatter {
    
    // MARK: Static-Properties
    
    /// The default `EUDCCDateFormatter` instance
    static let `default` = EUDCCDateFormatter()
    
    /// The Date-Only `ISO8601DateFormatter` instance
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.remove([.withTime, .withTimeZone])
        return formatter
    }()
    
    // MARK: Date from String
    
    /// Format Date from String
    /// - Parameter string: The Date String
    override func date(from string: String) -> Date? {
        super.date(from: string)
            ?? Self.dateFormatter.date(from: string)
    }
    
}
