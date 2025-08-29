import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var deepLinkHandler: DeepLinkHandler
    @State private var selection = Set<UUID>()
    @State private var showAdd = false
    @State private var previewItems: [Destination] = []
    @State private var showPreview = false
    @State private var showScanner = false

    var body: some View {
        DestinationListView(selection: $selection, previewItems: $previewItems, showPreview: $showPreview)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Import from QR") { showScanner = true }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(DataStore.quickTemplates) { template in
                            Button(template.name) { dataStore.add(template) }
                        }
                        Button("Custom") { showAdd = true }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    if !selection.isEmpty {
                        Button("Share as QR (\(selection.count))") {
                            previewItems = dataStore.destinations.filter { selection.contains($0.id) }
                            showPreview = true
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAdd) {
                DestinationEditView(destination: Destination(name: "", urlTemplate: ""), isNew: true)
            }
            .sheet(isPresented: $showPreview) {
                QRPreviewView(destinations: previewItems)
            }
            .sheet(isPresented: $showScanner) {
                QRScannerView { payload in
                    deepLinkHandler.process(payload)
                    showScanner = false
                }
            }
    }
}
