import 'flutter_scan_v2_platform_interface.dart';

class FlutterScanV2 {
  Future<String?> getPlatformVersion() {
    return FlutterScanV2Platform.instance.getPlatformVersion();
  }

  Future<String?> parse(String path) {
    return FlutterScanV2Platform.instance.parse(path);
  }
}
