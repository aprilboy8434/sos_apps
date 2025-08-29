import SwiftUI

struct ResultInfo: Identifiable {
    let id = UUID()
    let message: String
    let successes: [String]
    let failures: [String]
}

struct MainView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var locationManager: LocationManager
    @State private var lastSent: Date?
    @State private var resultInfo: ResultInfo?
    @State private var anim = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button(action: sendSOS) {
                    Text("SOS")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 240, height: 240)
                        .background(Circle().fill(Color.red))
                        .scaleEffect(anim ? 1.05 : 0.95)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: anim)
                }
                .onAppear { anim = true }
                .accessibilityLabel("Send SOS")
                .padding()
                Text(statusLine).padding(.top)
                Spacer()
            }
            .navigationTitle("OneTapSOS")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(item: $resultInfo) { info in
                ResultSheet(info: info)
            }
        }
    }

    var statusLine: String {
        if let lastSent {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return "Last sent: \(formatter.string(from: lastSent))"
        } else {
            return "Not sent yet"
        }
    }

    func sendSOS() {
        Haptics.playImpact()
        Task {
            let location = await locationManager.requestLocation()
            let timestamp = ISO8601DateFormatter().string(from: Date())
            var coordsText = "unavailable"
            if let loc = location {
                let lat = String(format: "%.6f", loc.coordinate.latitude)
                let lon = String(format: "%.6f", loc.coordinate.longitude)
                coordsText = "https://maps.apple.com/?ll=\(lat),\(lon) (\(lat), \(lon))"
            }
            let message = "SOS! I need help. Location: \(coordsText) at \(timestamp)"
            var successes: [String] = []
            var failures: [String] = []
            for dest in dataStore.destinations {
                guard let url = URLBuilder.url(for: dest.urlTemplate, message: message) else {
                    failures.append(dest.name)
                    continue
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    successes.append(dest.name)
                } else {
                    failures.append(dest.name)
                }
            }
            lastSent = Date()
            resultInfo = ResultInfo(message: message, successes: successes, failures: failures)
        }
    }
}

struct ResultSheet: View {
    let info: ResultInfo
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Message") {
                    Text(info.message).font(.footnote)
                    ShareLink(item: info.message)
                    Button("Copy") { UIPasteboard.general.string = info.message }
                }
                if !info.successes.isEmpty {
                    Section("Sent") {
                        ForEach(info.successes, id: \.self) { Text($0) }
                    }
                }
                if !info.failures.isEmpty {
                    Section("Failed") {
                        ForEach(info.failures, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("Results")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
