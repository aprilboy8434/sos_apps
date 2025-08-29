import XCTest
@testable import OneTapSOS
import CoreImage

final class QRCodeTests: XCTestCase {
    func testQRCodeRoundTrip() {
        let text = "Sample"
        guard let img = QRCode.generate(from: text) else {
            XCTFail("No image")
            return
        }
        let out = QRCode.decode(img)
        XCTAssertEqual(out, text)
    }
}
