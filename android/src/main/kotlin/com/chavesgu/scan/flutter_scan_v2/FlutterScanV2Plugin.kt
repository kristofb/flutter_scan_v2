package com.chavesgu.scan.flutter_scan_v2

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterScanV2Plugin */
class FlutterScanV2Plugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    var flutterPluginBinding: FlutterPluginBinding? = null
    private val _result: Result? = null
    private var task: QrCodeAsyncTask? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_scan_v2")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method.equals("parse")) {
            val path: String? = call.arguments as String?
            val task = QrCodeAsyncTask(this, path)
            task.execute(path)
        } else {
            result.notImplemented()
        }
    }

//    private fun configChannel(binding: ActivityPluginBinding) {
//        activity = binding.activity
//        channel = MethodChannel(flutterPluginBinding!!.binaryMessenger, "chavesgu/scan")
//        channel.setMethodCallHandler(this)
//        flutterPluginBinding!!.platformViewRegistry
//            .registerViewFactory(
//                "chavesgu/scan_view", ScanViewFactory(
//                    flutterPluginBinding!!.binaryMessenger,
//                    flutterPluginBinding!!.applicationContext,
//                    activity,
//                    binding
//                )
//            )
//    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        flutterPluginBinding = null
    }

    fun endOfTask(s: String) {
        _result?.success(s)
        task?.cancel(true)
        task = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        if (flutterPluginBinding != null) {
            // Register view
            flutterPluginBinding?.getPlatformViewRegistry()
                ?.registerViewFactory(
                    "flutter_scan_v2/scan_view", ScanViewFactory(
                        flutterPluginBinding!!.getBinaryMessenger(),
                        flutterPluginBinding!!.getApplicationContext(),
                        binding.activity,
                        binding
                    )
                )
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
