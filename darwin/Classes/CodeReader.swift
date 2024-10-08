import Vision
#if os(macOS)
import FlutterMacOS
#else
import Flutter
#endif

public class CodeReader {

  public static func detectQRCode(_ imagePath: String) -> [CIFeature]? {
      let url = NSURL.fileURL(withPath: imagePath);
      if let ciImage = CIImage.init(contentsOf: url) {
      var options: [String: Any];
      let context = CIContext();
      options = [CIDetectorAccuracy: CIDetectorAccuracyHigh];
      let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options);
      if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
        options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1];
      } else {
        options = [CIDetectorImageOrientation: 1];
      }
      let features = qrDetector?.features(in: ciImage, options: options);
      return features;
    }
    return nil
  }

  public static func detectBarCode(_ imagePath: String, result: @escaping FlutterResult) {
      let url = NSURL.fileURL(withPath: imagePath);
      if let ciImage = CIImage.init(contentsOf: url) {
      var requestHandler: VNImageRequestHandler;
      if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
        requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation(rawValue: ciImage.properties[(kCGImagePropertyOrientation as String)] as! UInt32) ?? .up, options: [:])
      } else {
        requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
      }
      let request = VNDetectBarcodesRequest { (request,error) in
        var res: String? = nil;
        if let observations = request.results as? [VNBarcodeObservation], !observations.isEmpty {
          let data: VNBarcodeObservation = observations.first!;
          res = data.payloadStringValue;
        }
        DispatchQueue.main.async {
          result(res);
        }
      }
      DispatchQueue.global(qos: .background).async {
        do{
          try requestHandler.perform([request])
        } catch {
          DispatchQueue.main.async {
            result(nil);
          }
        }
      }
    } else {
      result(nil);
    }
  }
}
