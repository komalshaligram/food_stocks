import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller = window.rootViewController as! FlutterViewController
             let flavorChannel = FlutterMethodChannel(
                     name: "flavor",
             binaryMessenger: controller.binaryMessenger)
             flavorChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                     // Note: this method is invoked on the UI thread
                     if call.method == "getFlavor" {
                         let flavor = Bundle.main.infoDictionary?["flavor"] as? String
                         result(flavor)
                     } else {
                         result(FlutterMethodNotImplemented)
                     }
             })
    

      if #available(iOS 10.0, *) {
           UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
         }
      
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

