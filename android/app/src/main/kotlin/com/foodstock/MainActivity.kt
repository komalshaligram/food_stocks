package com.foodstock

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Must call super so Flutter's plugin loader registers plugins once.
        // Do NOT also call GeneratedPluginRegistrant.registerWith — that double-registers
        // plugins and causes a release-build NPE on open (Unable to start MainActivity).
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "flavor"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getFlavor") {
                result.success(BuildConfig.FLAVOR)
            } else {
                result.notImplemented()
            }
        }
    }
}
