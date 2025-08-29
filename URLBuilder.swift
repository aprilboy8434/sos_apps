import Foundation

struct URLBuilder {
    static func url(for template: String, message: String) -> URL? {
        guard template.contains("{MESSAGE}") else { return nil }
        let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = template.replacingOccurrences(of: "{MESSAGE}", with: encoded)
        return URL(string: urlString)
    }
}
