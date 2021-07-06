import Foundation

// MARK: - Content

public extension EUDCC {
    
    /// The EUDCC Content
    enum Content: Hashable {
        /// Vaccination
        case vaccination(Vaccination)
        /// Test
        case test(Test)
        /// Recovery
        case recovery(Recovery)
    }
    
}
