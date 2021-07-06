import Foundation

// MARK: - AnyDateFormatter

/// Protocol acting as a common API for all types of date formatters
protocol AnyDateFormatter {
    
    /// The Formatter Input. Default value `Date`
    associatedtype Input = Date
    
    /// Format a given Input into a Date
    /// - Parameter string: The String to format
    func date(from input: Input) -> Date?
    
    /// Format a Date into the Input
    /// - Parameter date: The Date to format
    func string(from date: Date) -> Input
    
}

// MARK: - DateFormatter+AnyDateFormatter

extension DateFormatter: AnyDateFormatter {}

// MARK: - ISO8601DateFormatter+AnyDateFormatter

extension ISO8601DateFormatter: AnyDateFormatter {}
