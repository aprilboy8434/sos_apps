import XCTest
@testable import OneTapSOS

final class ImportTests: XCTestCase {
    func testImportValidation() throws {
        let item = DestinationItem(name: "Bad", urlTemplate: "sms:123")
        let bundle = ImportBundle(v: 1, type: "destination", items: [item], ts: "now")
        let data = try JSONEncoder().encode(bundle)
        let payload = Base64URL.encode(data)
        let handler = DeepLinkHandler(dataStore: DataStore())
        handler.handlePayloadString(payload)
        XCTAssertTrue(handler.importItems.isEmpty)
    }

    func testDuplicateSkipping() {
        let store = DataStore()
        let dest = Destination(name: "A", urlTemplate: "sms:{MESSAGE}")
        store.add(dest)
        let result = store.add(destinations: [dest])
        XCTAssertEqual(result.added, 0)
        XCTAssertEqual(result.skipped, 1)
    }
}
