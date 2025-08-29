import Foundation

struct Destination: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var urlTemplate: String

    init(id: UUID = UUID(), name: String, urlTemplate: String) {
        self.id = id
        self.name = name
        self.urlTemplate = urlTemplate
    }
}
