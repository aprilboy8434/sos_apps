import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCode {
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()

    static func generate(from string: String) -> CIImage? {
        let data = string.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        return filter.outputImage
    }

    static func decode(_ image: CIImage) -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: image) ?? []
        for feature in features {
            if let qr = feature as? CIQRCodeFeature {
                return qr.messageString
            }
        }
        return nil
    }
}
