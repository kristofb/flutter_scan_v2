import Flutter
import UIKit

public class FlutterScanV2Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_scan_v2", binaryMessenger: registrar.messenger())
    let instance = FlutterScanV2Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)

    case "parse":
      let path = call.arguments as! String;
      if let features = CodeReader.detectQRCode(UIImage.init(contentsOfFile: path)), !features.isEmpty {
        let data = features.first as! CIQRCodeFeature
        result(data.messageString);
      } else {
        self.detectBarCode(UIImage.init(contentsOfFile: path), result: result)
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
