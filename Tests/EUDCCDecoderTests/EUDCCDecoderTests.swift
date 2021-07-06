import XCTest
import EUDCC
@testable import EUDCCDecoder

final class EUDCCDecoderTests: XCTestCase {
    
    let qrCode = "HC1:NCFP70M90T9WTWGVLKJ99K83X4C8DTTMMX*4DBB3XK4F3A:OK.G2F3K*S7Y0/IC6TAY50.FK6ZK7:EDOLFVC*70B$D% D3IA4W5646946846.966KCN9E%961A6DL6FA7D46XJCCWENF6OF63W5KF60A6WJCT3EHS8WJC0FDTA6AIA%G7X+AQB9746IG77TA$96T476:6/Q6M*8CR63Y8R46WX8F46VL6/G8SF6DR64S8+96QK4.JCP9EJY8L/5M/5546.96VF6%JC QE/IAYJC5LEW34U3ET7DXC9 QE-ED8%E3KC.SC4KCD3DX47B46IL6646I*6..DX%DLPCG/DI C+0AD1AZJC1/D/IA:JC5WEI3D4WE*Y9 JC/.DQZ9$PC5$CUZCY$5Y$5JPCT3E5JDNA79%6F464W5%:6378POQUVQ2XNBOKE9V3DRXF3FW01Q5 EC EQ-*MJ94T-12AT$3LR3T: HZEBAQ7PDWT38Y53%VHW8G-4EP3R4$M40SD99C+0.YUC-V%3"
    
    
    func testDecode() throws {
        let decodingResult = EUDCCDecoder().decode(from: self.qrCode)
        guard case .success(let eudcc) = decodingResult else {
            return XCTFail("\(decodingResult)")
        }
        let data = try JSONEncoder().encode(eudcc)
        let decodedEUDCC = try JSONDecoder().decode(EUDCC.self, from: data)
        XCTAssert(decodedEUDCC == eudcc)
    }
    
}
