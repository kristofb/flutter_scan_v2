import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scan_v2/flutter_scan_v2.dart';
import 'package:flutter_scan_v2/flutter_scan_v2_platform_interface.dart';
import 'package:flutter_scan_v2/flutter_scan_v2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterScanV2Platform
    with MockPlatformInterfaceMixin
    implements FlutterScanV2Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterScanV2Platform initialPlatform = FlutterScanV2Platform.instance;

  test('$MethodChannelFlutterScanV2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterScanV2>());
  });

  test('getPlatformVersion', () async {
    FlutterScanV2 flutterScanV2Plugin = FlutterScanV2();
    MockFlutterScanV2Platform fakePlatform = MockFlutterScanV2Platform();
    FlutterScanV2Platform.instance = fakePlatform;

    expect(await flutterScanV2Plugin.getPlatformVersion(), '42');
  });
}
