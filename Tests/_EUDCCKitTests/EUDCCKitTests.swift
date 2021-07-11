// MARK: - Exported Imports

@_exported import EUDCC
@_exported import EUDCCDecoder
@_exported import EUDCCValidator
@_exported import EUDCCVerifier
@_exported import XCTest

// MARK: - EUDCCKitTests

/// An EUDCCKitTests acting as a base/common TestCase
open class EUDCCKitTests: XCTestCase {
    
    // MARK: Properties
    
    /// The valid EUDCC Base-45 representation
    public let validEUDCCBase45Representation = "HC1:NCFP70M90T9WTWGVLKJ99K83X4C8DTTMMX*4DBB3XK4F3A:OK.G2F3K*S7Y0/IC6TAY50.FK6ZK7:EDOLFVC*70B$D% D3IA4W5646946846.966KCN9E%961A6DL6FA7D46XJCCWENF6OF63W5KF60A6WJCT3EHS8WJC0FDTA6AIA%G7X+AQB9746IG77TA$96T476:6/Q6M*8CR63Y8R46WX8F46VL6/G8SF6DR64S8+96QK4.JCP9EJY8L/5M/5546.96VF6%JC QE/IAYJC5LEW34U3ET7DXC9 QE-ED8%E3KC.SC4KCD3DX47B46IL6646I*6..DX%DLPCG/DI C+0AD1AZJC1/D/IA:JC5WEI3D4WE*Y9 JC/.DQZ9$PC5$CUZCY$5Y$5JPCT3E5JDNA79%6F464W5%:6378POQUVQ2XNBOKE9V3DRXF3FW01Q5 EC EQ-*MJ94T-12AT$3LR3T: HZEBAQ7PDWT38Y53%VHW8G-4EP3R4$M40SD99C+0.YUC-V%3"
    
    // MARK: XCTestCase-Lifecycle
    
    /// SetUp
    open override func setUp() {
        super.setUp()
        // Disable continueAfterFailure
        self.continueAfterFailure = false
    }
    
    // MARK: Helper-Functions
    
    /// Perform Test
    /// - Parameters:
    ///   - name: The name of the test
    ///   - timeout: The timeout
    ///   - test: The test execution
    public final func performTest(
        name: String = "\(#file) L\(#line):\(#column) \(#function)",
        timeout: TimeInterval = 10,
        test: (XCTestExpectation) -> Void
    ) {
        // Create expectation with function name
        let expectation = self.expectation(description: name)
        // Perform test with expectation
        test(expectation)
        // Wait for expectation been fulfilled with custom or default timeout
        self.waitForExpectations(
            timeout: timeout,
            handler: nil
        )
    }
    
}
