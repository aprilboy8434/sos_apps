import Foundation

struct ImportStats {
    let added: Int
    let skipped: Int
}

class DataStore: ObservableObject {
    @Published var destinations: [Destination] = []
    private let key = "destinations"

    init() {
        load()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Destination].self, from: data) else { return }
        destinations = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(destinations) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ destination: Destination) {
        destinations.append(destination)
        save()
    }

    func update(_ destination: Destination) {
        if let index = destinations.firstIndex(where: { $0.id == destination.id }) {
            destinations[index] = destination
            save()
        }
    }

    func remove(at offsets: IndexSet) {
        destinations.remove(atOffsets: offsets)
        save()
    }

    func add(destinations new: [Destination]) -> ImportStats {
        var added = 0
        var skipped = 0
        for dest in new {
            if destinations.contains(where: { $0.name == dest.name && $0.urlTemplate == dest.urlTemplate }) {
                skipped += 1
                continue
            }
            destinations.append(dest)
            added += 1
        }
        save()
        return ImportStats(added: added, skipped: skipped)
    }

    static let quickTemplates: [Destination] = [
        Destination(name: "SMS", urlTemplate: "sms:&body={MESSAGE}"),
        Destination(name: "WhatsApp", urlTemplate: "whatsapp://send?text={MESSAGE}"),
        Destination(name: "LINE", urlTemplate: "line://msg/text/{MESSAGE}"),
        Destination(name: "Telegram", urlTemplate: "tg://msg_url?url={MESSAGE}"),
        Destination(name: "Email", urlTemplate: "mailto:?body={MESSAGE}")
    ]
}
