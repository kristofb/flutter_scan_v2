import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_scan_v2_platform_interface.dart';

class FlutterScanV2 {
  Future<String?> getPlatformVersion() {
    return FlutterScanV2Platform.instance.getPlatformVersion();
  }

  Future<String?> parse(String path) {
    return FlutterScanV2Platform.instance.parse(path);
  }
}

typedef CaptureCallback = Function(String data);

class ScanController {
  MethodChannel? _channel;

  ScanController();

  void resume() => _channel?.invokeMethod("resume");

  void pause() => _channel?.invokeMethod("pause");

  void toggleTorchMode() => _channel?.invokeMethod("toggleTorchMode");
}

class ScanView extends StatefulWidget {
  final ScanController? controller;
  final CaptureCallback? onCapture;
  final Color scanLineColor;
  final double scanAreaScale;

  const ScanView({
    super.key,
    this.controller,
    this.onCapture,
    this.scanLineColor = Colors.green,
    this.scanAreaScale = 0.7,
  })  : assert(scanAreaScale <= 1.0, 'scanAreaScale must <= 1.0'),
        assert(scanAreaScale > 0.0, 'scanAreaScale must > 0.0');

  @override
  State<StatefulWidget> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  MethodChannel? _channel;

  @override
  Widget build(BuildContext context) {
    final creationParams = {
      "r": widget.scanLineColor.red,
      "g": widget.scanLineColor.green,
      "b": widget.scanLineColor.blue,
      "a": widget.scanLineColor.opacity,
      "scale": widget.scanAreaScale,
    };

    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'flutter_scan_v2/scan_view',
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
        onPlatformViewCreated: (id) => _onPlatformViewCreated(id),
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'flutter_scan_v2/scan_view',
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
        onPlatformViewCreated: (id) => _onPlatformViewCreated(id),
      );
    } else {
      return const Text("ScanView is not supported on this platform");
    }
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('flutter_scan_v2/scan/method_$id');
    _channel?.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        if (widget.onCapture != null) {
          widget.onCapture!(call.arguments.toString());
        }
      }
    });
    widget.controller?._channel = _channel;
  }
}
