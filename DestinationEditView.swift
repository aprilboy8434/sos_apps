import SwiftUI

struct DestinationEditView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) var dismiss
    @State var destination: Destination
    var isNew: Bool = false
    @State private var showPreview = false
    @State private var error: String?

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $destination.name)
                TextField("URL Template", text: $destination.urlTemplate)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if let error {
                    Text(error).foregroundColor(.red)
                }
                Button("Test Open") {
                    guard let url = URLBuilder.url(for: destination.urlTemplate, message: "Test") else {
                        error = "Invalid template"
                        return
                    }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        error = "Cannot open URL"
                    }
                }
            }
            Section {
                Button("Share as QR") { showPreview = true }
            }
        }
        .navigationTitle(isNew ? "New Destination" : "Edit Destination")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .sheet(isPresented: $showPreview) {
            QRPreviewView(destinations: [destination])
        }
    }

    func save() {
        guard destination.urlTemplate.contains("{MESSAGE}") else {
            error = "Template must contain {MESSAGE}"
            return
        }
        if isNew {
            dataStore.add(destination)
        } else {
            dataStore.update(destination)
        }
        dismiss()
    }
}
