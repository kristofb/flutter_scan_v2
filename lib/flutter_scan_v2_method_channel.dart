import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_scan_v2_platform_interface.dart';

/// An implementation of [FlutterScanV2Platform] that uses method channels.
class MethodChannelFlutterScanV2 extends FlutterScanV2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_scan_v2');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> parse(String path) async {
    final String? result = await methodChannel.invokeMethod('parse', path);
    return result;
  }
}
