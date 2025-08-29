import Foundation

struct DestinationItem: Codable {
    let name: String
    let urlTemplate: String
}

struct ImportBundle: Codable {
    let v: Int
    let type: String
    let items: [DestinationItem]
    let ts: String
}

class DeepLinkHandler: ObservableObject {
    @Published var showImport = false
    @Published var importItems: [Destination] = []
    let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }

    func handle(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        if components.host == "import", let payload = components.queryItems?.first(where: { $0.name == "payload" })?.value {
            handlePayloadString(payload)
        }
    }

    func process(_ string: String) {
        if string.hasPrefix("OTS:") {
            let payload = String(string.dropFirst(4))
            handlePayloadString(payload)
        } else if let url = URL(string: string) {
            handle(url: url)
        }
    }

    func handlePayloadString(_ payload: String) {
        guard let data = Base64URL.decode(payload),
              let bundle = try? JSONDecoder().decode(ImportBundle.self, from: data) else { return }
        let destinations = bundle.items
            .filter { $0.urlTemplate.contains("{MESSAGE}") }
            .map { Destination(name: $0.name, urlTemplate: $0.urlTemplate) }
        guard !destinations.isEmpty else { return }
        importItems = destinations
        showImport = true
    }
}
