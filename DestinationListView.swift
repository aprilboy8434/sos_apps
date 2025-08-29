import SwiftUI

struct DestinationListView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var selection: Set<UUID>
    @Binding var previewItems: [Destination]
    @Binding var showPreview: Bool

    var body: some View {
        List(selection: $selection) {
            ForEach(dataStore.destinations) { dest in
                NavigationLink(destination: DestinationEditView(destination: dest)) {
                    Text(dest.name)
                }
                .contextMenu {
                    Button("Share as QR") {
                        previewItems = [dest]
                        showPreview = true
                    }
                }
            }
            .onDelete { dataStore.remove(at: $0) }
        }
    }
}
