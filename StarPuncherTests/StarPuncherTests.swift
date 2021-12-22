import XCTest

@testable import StarPuncher
class StarPuncherTests: XCTestCase {
    func testSinWaveValues() {
        XCTAssertEqual(sin(0.0), 0.0)
        XCTAssertEqual(sin(Double.pi*2), 0.0, accuracy: 0.001)
        XCTAssertEqual(sin(Double.pi), 0.0, accuracy: 0.001)
        XCTAssertEqual(sin(Double.pi/2), 1.0, accuracy: 0.001)
        XCTAssertEqual(sin(Double.pi/2*3), -1.0, accuracy: 0.001)
    }
    
    func testTriangleWaveValues() {
        XCTAssertEqual(triangleWave(0.0), 0.0)
        XCTAssertEqual(triangleWave(Double.pi*2), 0.0, accuracy: 0.001)
        XCTAssertEqual(triangleWave(Double.pi), 0.0, accuracy: 0.001)
        XCTAssertEqual(triangleWave(Double.pi/2), 1.0, accuracy: 0.001)
        XCTAssertEqual(triangleWave(Double.pi/2*3), -1.0, accuracy: 0.001)
    }
    
    func testSawWaveValues() {
        XCTAssertEqual(sawWave(0.0), 0.0)
        XCTAssertEqual(sawWave(Double.pi*2), 0.0, accuracy: 0.001)
        XCTAssertEqual(sawWave(Double.pi), 1.0, accuracy: 0.001)
    }
}
