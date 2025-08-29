import SwiftUI
import CoreImage

struct QRPreviewView: View {
    var destinations: [Destination]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            let payload = makePayload()
            let link = "onetapsos://import?payload=\(payload)"
            let image = QRCode.generate(from: link) ?? CIImage()
            let uiImage = UIImage(ciImage: image.transformed(by: CGAffineTransform(scaleX: 10, y: 10)))
            VStack(spacing: 20) {
                Image(uiImage: uiImage)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 250, height: 250)
                Text("Scan with OneTapSOS to import")
                Text(link)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                ShareLink(item: link) { Text("Share") }
                Button("Copy Link") { UIPasteboard.general.string = link }
            }
            .padding()
            .navigationTitle("QR Code")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    func makePayload() -> String {
        let items = destinations.map { DestinationItem(name: $0.name, urlTemplate: $0.urlTemplate) }
        let bundle = ImportBundle(v: 1, type: destinations.count == 1 ? "destination" : "bundle", items: items, ts: ISO8601DateFormatter().string(from: Date()))
        let data = try! JSONEncoder().encode(bundle)
        return Base64URL.encode(data)
    }
}
