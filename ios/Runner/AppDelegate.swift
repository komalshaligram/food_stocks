import UIKit
import Flutter
import VisionKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let nativeScannerChannel = "scanner.tavili.com/native_scanner"
  private var nativePhotoCaptureDelegate: NativePhotoCaptureDelegate?
  private var nativeDocumentScanDelegate: NativeDocumentScanDelegate?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)

    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return didFinish
    }

    let flavorChannel = FlutterMethodChannel(
      name: "flavor",
      binaryMessenger: controller.binaryMessenger
    )
    flavorChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getFlavor" {
        let flavor = Bundle.main.infoDictionary?["flavor"] as? String
        result(flavor)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    registerScannerChannel(controller: controller)

    return didFinish
  }

  private func registerScannerChannel(controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: nativeScannerChannel,
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard let controller = self?.topViewController() else {
        result(
          FlutterError(
            code: "no_controller",
            message: "No active view controller available",
            details: nil
          )
        )
        return
      }

      switch call.method {
      case "captureDocumentPhoto":
        self?.startNativePhotoCapture(from: controller, result: result)
      case "captureDocumentScan":
        self?.startNativeDocumentScan(from: controller, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }

    let keyWindow = scenes
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow })

    var top = keyWindow?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }

  private func startNativePhotoCapture(from controller: UIViewController, result: @escaping FlutterResult) {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      result(
        FlutterError(
          code: "camera_unavailable",
          message: "Camera is not available on this device",
          details: nil
        )
      )
      return
    }

    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.cameraCaptureMode = .photo

    let delegate = NativePhotoCaptureDelegate { [weak self] outputPath in
      self?.nativePhotoCaptureDelegate = nil
      result(outputPath)
    } onError: { [weak self] code, message in
      self?.nativePhotoCaptureDelegate = nil
      result(FlutterError(code: code, message: message, details: nil))
    }

    nativePhotoCaptureDelegate = delegate
    picker.delegate = delegate
    controller.present(picker, animated: true)
  }

  private func startNativeDocumentScan(from controller: UIViewController, result: @escaping FlutterResult) {
    if #available(iOS 13.0, *), VNDocumentCameraViewController.isSupported {
      let scanner = VNDocumentCameraViewController()
      let delegate = NativeDocumentScanDelegate { [weak self] paths in
        self?.nativeDocumentScanDelegate = nil
        result(paths)
      } onCancel: { [weak self] in
        self?.nativeDocumentScanDelegate = nil
        result(nil)
      } onError: { [weak self] code, message in
        self?.nativeDocumentScanDelegate = nil
        result(FlutterError(code: code, message: message, details: nil))
      }
      nativeDocumentScanDelegate = delegate
      scanner.delegate = delegate
      controller.present(scanner, animated: true)
      return
    }

    startNativePhotoCapture(from: controller) { photoPath in
      if let path = photoPath as? String, !path.isEmpty {
        result([path])
      } else {
        result(nil)
      }
    }
  }
}

final class NativePhotoCaptureDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  private let onComplete: (String?) -> Void
  private let onError: (String, String) -> Void

  init(
    onComplete: @escaping (String?) -> Void,
    onError: @escaping (String, String) -> Void
  ) {
    self.onComplete = onComplete
    self.onError = onError
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) {
      self.onComplete(nil)
    }
  }

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.originalImage] as? UIImage else {
      picker.dismiss(animated: true) {
        self.onError("capture_failed", "Could not read captured image")
      }
      return
    }

    guard let data = image.jpegData(compressionQuality: 0.95) else {
      picker.dismiss(animated: true) {
        self.onError("encode_failed", "Could not encode captured image")
      }
      return
    }

    let path = URL(fileURLWithPath: NSTemporaryDirectory())
      .appendingPathComponent("native_capture_\(Int(Date().timeIntervalSince1970 * 1000)).jpg")

    do {
      try data.write(to: path, options: .atomic)
      picker.dismiss(animated: true) {
        self.onComplete(path.path)
      }
    } catch {
      picker.dismiss(animated: true) {
        self.onError("write_failed", "Could not save captured image")
      }
    }
  }
}

@available(iOS 13.0, *)
final class NativeDocumentScanDelegate: NSObject, VNDocumentCameraViewControllerDelegate {
  private let onComplete: ([String]) -> Void
  private let onCancel: () -> Void
  private let onError: (String, String) -> Void

  init(
    onComplete: @escaping ([String]) -> Void,
    onCancel: @escaping () -> Void,
    onError: @escaping (String, String) -> Void
  ) {
    self.onComplete = onComplete
    self.onCancel = onCancel
    self.onError = onError
  }

  func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
    controller.dismiss(animated: true) {
      self.onCancel()
    }
  }

  func documentCameraViewController(
    _ controller: VNDocumentCameraViewController,
    didFailWithError error: Error
  ) {
    controller.dismiss(animated: true) {
      self.onError("vn_scan_failed", error.localizedDescription)
    }
  }

  func documentCameraViewController(
    _ controller: VNDocumentCameraViewController,
    didFinishWith scan: VNDocumentCameraScan
  ) {
    var outputPaths: [String] = []
    let fm = FileManager.default
    let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      .appendingPathComponent("vn_document_scans", isDirectory: true)

    do {
      try fm.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)
    } catch {
      controller.dismiss(animated: true) {
        self.onError("vn_temp_dir_failed", "Could not create temp directory")
      }
      return
    }

    let timestamp = Int(Date().timeIntervalSince1970 * 1000)
    for index in 0..<scan.pageCount {
      let image = scan.imageOfPage(at: index)
      guard let data = image.jpegData(compressionQuality: 0.96) else {
        continue
      }
      let fileURL = tempDir.appendingPathComponent("vn_scan_\(timestamp)_\(index + 1).jpg")
      do {
        try data.write(to: fileURL, options: .atomic)
        outputPaths.append(fileURL.path)
      } catch {
        continue
      }
    }

    controller.dismiss(animated: true) {
      if outputPaths.isEmpty {
        self.onError("vn_no_pages", "No scanned pages were exported")
      } else {
        self.onComplete(outputPaths)
      }
    }
  }
}
