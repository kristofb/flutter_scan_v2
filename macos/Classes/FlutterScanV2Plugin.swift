import Cocoa
import FlutterMacOS

public class FlutterScanV2Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_scan_v2", binaryMessenger: registrar.messenger)
    let instance = FlutterScanV2Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)

    case "parse":
        let path = call.arguments as! String;
        if let features = CodeReader.detectQRCode(path), !features.isEmpty {
            let data = features.first as! CIQRCodeFeature
            result(data.messageString);
        } else {
            CodeReader.detectBarCode(path, result: result)
        }

    case "parseQR":
        let path = call.arguments as! String;
        if let features = CodeReader.detectQRCode(path), !features.isEmpty {
            let data = features.first as! CIQRCodeFeature
            result(data.messageString);
        } else {
            result(nil);
        }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
