import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    var completion: (String) -> Void
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> ScannerController {
        let controller = ScannerController()
        controller.completion = { str in
            completion(str)
            dismiss()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: ScannerController, context: Context) {}

    class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
        var completion: ((String) -> Void)?
        let session = AVCaptureSession()

        override func viewDidLoad() {
            super.viewDidLoad()
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device) else { return }
            session.addInput(input)
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.frame = view.bounds
            preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(preview)
            session.startRunning()
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let str = obj.stringValue {
                session.stopRunning()
                completion?(str)
            }
        }
    }
}
