import XCTest
@testable import OneTapSOS

final class Base64URLTests: XCTestCase {
    func testRoundTrip() {
        let string = "Hello, world!"
        let data = string.data(using: .utf8)!
        let encoded = Base64URL.encode(data)
        let decoded = Base64URL.decode(encoded)
        XCTAssertEqual(string, String(data: decoded!, encoding: .utf8))
    }
}
