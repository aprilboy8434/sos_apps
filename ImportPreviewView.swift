import SwiftUI

struct ImportPreviewView: View {
    @EnvironmentObject var dataStore: DataStore
    let destinations: [Destination]
    @State private var selected: Set<UUID>
    @State private var result: ImportResult?
    @Environment(\.dismiss) var dismiss

    init(destinations: [Destination]) {
        self.destinations = destinations
        _selected = State(initialValue: Set(destinations.map { $0.id }))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(destinations) { dest in
                    Toggle(isOn: binding(for: dest)) {
                        HStack {
                            Text(dest.name)
                            if dataStore.destinations.contains(where: { $0.name == dest.name && $0.urlTemplate == dest.urlTemplate }) {
                                Badge(text: "Duplicate")
                            } else if dataStore.destinations.contains(where: { $0.name == dest.name }) {
                                Badge(text: "Conflict")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Import")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Import") { importSelected() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert(item: $result) { res in
                Alert(title: Text("Import"), message: Text(res.text), dismissButton: .default(Text("OK")) { dismiss() })
            }
        }
    }

    func binding(for dest: Destination) -> Binding<Bool> {
        Binding(
            get: { selected.contains(dest.id) },
            set: { if $0 { selected.insert(dest.id) } else { selected.remove(dest.id) } }
        )
    }

    func importSelected() {
        let chosen = destinations.filter { selected.contains($0.id) }
        let res = dataStore.add(destinations: chosen)
        result = ImportResult(text: "Added \(res.added), Skipped \(res.skipped)")
    }
}

struct Badge: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(4)
    }
}

struct ImportResult: Identifiable {
    let id = UUID()
    let text: String
}
