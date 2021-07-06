import Foundation

// MARK: - EUDCCTimestampFormatter

/// A EUDCC Timestamp Formatter
final class EUDCCTimestampFormatter: AnyDateFormatter {
    
    // MARK: Static-Properties
    
    /// The default `EUDCCTimestampFormatter` instance
    static let `default` = EUDCCTimestampFormatter()
    
    // MARK: AnyDateFormatter
    
    /// Format a given Input into a Date
    /// - Parameter string: The String to format
    func date(from input: Int) -> Date? {
        .init(timeIntervalSince1970: .init(input))
    }
    
    /// Format a Date into the Input
    /// - Parameter date: The Date to format
    func string(from date: Date) -> Int {
        .init(date.timeIntervalSince1970)
    }
    
}
