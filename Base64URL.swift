import Foundation

struct Base64URL {
    static func encode(_ data: Data) -> String {
        let base = data.base64EncodedString()
        return base.replacingOccurrences(of: "+", with: "-")
                   .replacingOccurrences(of: "/", with: "_")
                   .replacingOccurrences(of: "=", with: "")
    }

    static func decode(_ string: String) -> Data? {
        var base = string.replacingOccurrences(of: "-", with: "+")
                         .replacingOccurrences(of: "_", with: "/")
        let padding = 4 - base.count % 4
        if padding < 4 {
            base += String(repeating: "=", count: padding)
        }
        return Data(base64Encoded: base)
    }
}
