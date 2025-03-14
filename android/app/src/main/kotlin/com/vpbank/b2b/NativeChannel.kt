package com.vpbank.b2b

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.scottyab.rootbeer.RootBeer

class NativeChannel {
    private val channel = "com.vpbank/native_channel"

    fun init(flutterEngine: FlutterEngine, context: Context, activity: MainActivity) {
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                channel
        ).setMethodCallHandler { call, result ->
            val arguments = call.arguments as Map<String, Object>?
            try {
                if (call.method == "isThisCompromised") {
                    val rootBeer = RootBeer(context)
                    rootBeer.setLogging(true)
                    result.success(rootBeer.isRooted)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}