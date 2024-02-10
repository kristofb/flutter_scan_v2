import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_scan_v2_method_channel.dart';

abstract class FlutterScanV2Platform extends PlatformInterface {
  /// Constructs a FlutterScanV2Platform.
  FlutterScanV2Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterScanV2Platform _instance = MethodChannelFlutterScanV2();

  /// The default instance of [FlutterScanV2Platform] to use.
  ///
  /// Defaults to [MethodChannelFlutterScanV2].
  static FlutterScanV2Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterScanV2Platform] when
  /// they register themselves.
  static set instance(FlutterScanV2Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
