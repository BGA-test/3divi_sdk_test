package com.example.face3divi_test

import android.content.pm.ApplicationInfo;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.FlutterInjector;

class MainActivity : FlutterActivity() {
    companion object {
        init {
            System.loadLibrary("facerec")
        }

        private const val CHANNEL = "samples.flutter.dev/facesdk"
    }

    private fun getNativeLibDir(): String {
        return applicationInfo.nativeLibraryDir
    }

    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    //         .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
    //             if (call.method == "getNativeLibDir") {
    //                 val nativeLibDir = getNativeLibDir()
    //                 result.success(nativeLibDir)
    //             } else {
    //                 result.notImplemented()
    //             }
    //         }
    // }
}
