import SwiftUI

class AppState: ObservableObject {
    let dataStore = DataStore()
    let locationManager = LocationManager()
    lazy var deepLinkHandler = DeepLinkHandler(dataStore: dataStore)
}

@main
struct OneTapSOSApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState.dataStore)
                .environmentObject(appState.locationManager)
                .environmentObject(appState.deepLinkHandler)
                .onOpenURL { url in
                    appState.deepLinkHandler.handle(url: url)
                }
                .sheet(isPresented: $appState.deepLinkHandler.showImport) {
                    ImportPreviewView(destinations: appState.deepLinkHandler.importItems)
                        .environmentObject(appState.dataStore)
                }
        }
    }
}
