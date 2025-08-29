import XCTest
@testable import OneTapSOS

final class DeepLinkTests: XCTestCase {
    func testDeepLinkParsing() throws {
        let item = DestinationItem(name: "Test", urlTemplate: "sms:{MESSAGE}")
        let bundle = ImportBundle(v: 1, type: "destination", items: [item], ts: "now")
        let data = try JSONEncoder().encode(bundle)
        let payload = Base64URL.encode(data)
        let url = URL(string: "onetapsos://import?payload=\(payload)")!
        let handler = DeepLinkHandler(dataStore: DataStore())
        handler.handle(url: url)
        XCTAssertEqual(handler.importItems.first?.name, "Test")
    }
}
