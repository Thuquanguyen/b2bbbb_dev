package com.vpbank.b2b

import android.content.Context
import android.os.Build
import android.os.Handler
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import vn.mk.otp.OtpSdk
import vn.mk.token.sdk.SdkNative

class SmartOTPManager {
    private val channel = "com.vpbank/smart_otp_channel"
    private var sIsRunningOnEmulator: Boolean? = null

    val TAG = "------SmartOTPManager"

    private fun byteToInt(bytes: ByteArray): Int {
        Log.d(TAG, "byteToInt")
        return String(bytes).toInt();
    }

    private fun isRunningOnEmulator(): Boolean {
        var result = sIsRunningOnEmulator
        if (result != null)
            return result
        // Android SDK emulator
        result = (Build.FINGERPRINT.startsWith("google/sdk_gphone_")
                && Build.FINGERPRINT.endsWith(":user/release-keys")
                && Build.MANUFACTURER == "Google" && Build.PRODUCT.startsWith("sdk_gphone_") && Build.BRAND == "google"
                && Build.MODEL.startsWith("sdk_gphone_"))
                //
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                //bluestacks
                || "QC_Reference_Phone" == Build.BOARD && !"Xiaomi".equals(
            Build.MANUFACTURER,
            ignoreCase = true
        ) //bluestacks
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.HOST == "Build2" //MSI App Player
                || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                || Build.PRODUCT == "google_sdk"
        // another Android SDK emulator check
//        || SystemProperties.getProp("ro.kernel.qemu") == "1"
        sIsRunningOnEmulator = result
        return result
    }

    fun init(flutterEngine: FlutterEngine, context: Context, activity: MainActivity) {
        //Not run on simolator
//    if (isRunningOnEmulator()) {
//      return
//    }

        OtpSdk.init(context);
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            val arguments = call.arguments as Map<String, Object>?
            try {
                if (call.method == "doActive") {
                    if (arguments == null) {
                        result.success("No params")
                    } else {
                        val activeCode = arguments["active_code"] as String
                        val pushToken = arguments["push_token"] as String
                        val appId = arguments["app_id"] as String
                        val activeUrl = arguments["active_url"] as String
                        Log.d(TAG, "Active code $activeCode")

//                        val resultCode: ByteArray =
//                            SdkNative.getInstance().doActive(activeCode, pushToken, appId, activeUrl)
//                        val sdkResult = byteToInt(resultCode)
//                        Log.d(TAG, "doActive $sdkResult")
//
//                        result.success(sdkResult)

                        Thread(Runnable {
                            try {
                                val resultCode: ByteArray =
                                    SdkNative.getInstance().doActive(activeCode, pushToken, appId, activeUrl)

                                Log.d(TAG, "doActive ${byteToInt(resultCode)}")
                                activity.runOnUiThread(Runnable {
                                    result.success(byteToInt(resultCode))
                                })
                            } catch (e: Exception) {
                                e.printStackTrace()
                                activity.runOnUiThread(Runnable {
                                    result.success(null)
                                })
                            }
                        }).start()

                    }

                } else if (call.method == "deleteAllExistingTokens") {
                    SdkNative.getInstance().deleteAllExistingTokens();
                    result.success(null)
                } else if (call.method == "setPIN") {
                    if (arguments == null || arguments["pin"] == null) {
                        result.error("INPUT_DATA_INVALID", "Pin must be not empty", null)
                    } else {
                        val pin = arguments["pin"] as String
                        SdkNative.getInstance().setPin(pin);
                        result.success(null)
                    }
                } else if (call.method == "changePIN") {
                    if (arguments == null || arguments["pin"] == null || arguments["new_pin"] == null) {
                        result.error("INPUT_DATA_INVALID", "Pin must be not empty", null)
                    } else {
                        val pin = arguments["pin"] as String
                        val newPin = arguments["new_pin"] as String
                        SdkNative.getInstance().changePin(pin, newPin);
                        result.success(null)
                    }
                } else if (call.method == "loginPIN") {
                    if (arguments == null || arguments["pin"] == null) {
                        result.error("INPUT_DATA_INVALID", "Pin must be not empty", null)
                    } else {
                        val pin = arguments["pin"] as String
                        val resultCode: ByteArray = SdkNative.getInstance().loginPin(pin)
                        result.success(byteToInt(resultCode))
                    }
                } else if (call.method == "checkUserIdExistence") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "UserId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        val resultCode = SdkNative.getInstance().checkUserIdExistence(userId)
                        result.success(resultCode)
                    }
                } else if (call.method == "checkAppActivated") {
                    val resultCode = SdkNative.getInstance().checkAppActivated()
                    result.success(resultCode)

                } else if (call.method == "checkAppActivated2") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        val tokenSn = String(SdkNative.getInstance().getTokenSnWithUserId(userId));
                        val resultCode =
                            SdkNative.getInstance().checkActiveToken2(userId, tokenSn)
                        val data = String(resultCode)
                        Log.d(TAG,"checkAppActivated2 $userId value $data")
                        result.success(data)
                    }
                } else if (call.method == "setSelectedUserId") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        SdkNative.getInstance().setSelectedUserId(userId)
                        result.success(null)
                    }
                } else if (call.method == "checkActivatedPIN") {
                    val resultCode = SdkNative.getInstance().checkActivatedPINCODE()
                    result.success(resultCode)
                } else if (call.method == "getSelectedUserId") {
                    val selectedUserId = SdkNative.getInstance().selectedUserId
                    result.success(selectedUserId)
                } else if (call.method == "getOTP") {
                    val resultCode: ByteArray = SdkNative.getInstance().otPv2
                    result.success(String(resultCode))
                } else if (call.method == "getTokenSn") {
                    val tokenSn = SdkNative.getInstance().tokenSn
                    result.success(String(tokenSn))
                } else if (call.method == "getCurrentServerTime") {
                    val currentServerTime = SdkNative.getInstance().currentServerTime
                    result.success(byteToInt(currentServerTime))
                } else if (call.method == "getCRotpWithTransaction") {
                    if (arguments == null || arguments["transaction_info"] == null || arguments["challenge_code"] == null) {
                        result.error("INPUT_DATA_INVALID", "Transaction info not found", null)
                    } else {
                        val transactionInfo = arguments["transaction_info"] as String
                        val challengeCode = arguments["challenge_code"] as String
                        val resultCode =
                            SdkNative.getInstance().getCRotpWithTransactionInfo(transactionInfo, challengeCode)
                        result.success(String(resultCode))
                    }
                } else if (call.method == "getTimeStep") {
                    val timeStep = SdkNative.getInstance().timeStep
                    result.success(timeStep)
                } else if (call.method == "getTransactionInfo") {
                    if (arguments == null || arguments["transaction_id"] == null || arguments["message_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "Transaction info not found", null)
                    } else {
                        val transactionId = arguments["transaction_id"] as String
                        val messageId = arguments["message_id"] as String
                        val transInfo = SdkNative.getInstance().getTransactionInfo(transactionId, messageId)
                        result.success(String(transInfo))
                    }
                } else if (call.method == "doSyncTime") {
                    val resultCode = SdkNative.getInstance().doSyncTime()
                    result.success(byteToInt(resultCode))
                } else if (call.method == "synchronizeSoftOtp") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        val transInfo = SdkNative.getInstance().synchronizeSoftOtp(userId)
                        result.success(transInfo)
                    }
                } else if (call.method == "decryptQRCodeDataWithUserId") {
                    if (arguments == null || arguments["qr_code_string"] == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val qrCodeString = arguments["qr_code_string"] as String
                        val userId = arguments["user_id"] as String
                        val transInfo =
                            SdkNative.getInstance().decryptQRCodeDataWithUserId(userId, qrCodeString)
                        result.success(String(transInfo))
                    }
                } else if (call.method == "deleteAllExistingTokens") {
                    SdkNative.getInstance().deleteAllExistingTokens();
                    result.success(null)
                } else if (call.method == "isHadActivatedUserOnDevice") {
                    //        let result_ = SmartOTPManager.shared.isHadActivedUserOnDevice()
                    //        result(result_)
                } else if (call.method == "getUserNameActivated") {
                    //        var masked = true
                    //        if let arguments = call.arguments as? [String: Any], let masked_ = arguments["masked"] as? Bool {
                    //          masked = masked_
                    //        }
                    //        let userName = SmartOTPManager.shared.getUserNameActivated(isMask: masked)
                    //        result(userName)
                    var masked = true
                    if (arguments != null && arguments["masked"] != null) {
                        masked = arguments["masked"] as Boolean
                    }
                    result.success(null)

                } else if (call.method == "getFullNameActivated") {
                    //        var masked = true
                    //        if let arguments = call.arguments as? [String: Any], let masked_ = arguments["masked"] as? Bool {
                    //          masked = masked_
                    //        }
                    //        let fullName = SmartOTPManager.shared.getFullNameActivated(isMask: masked)
                    result.success("")
                } else if (call.method == "checkUserActivatedAnyDevices") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        val resultCode = SdkNative.getInstance()
                            .checkActiveToken2(userId, String(SdkNative.getInstance().tokenSn))
                        result.success(String(resultCode))
                    }
                } else if (call.method == "checkTokenIsValid") {
                    //        let result_ = SmartOTPManager.shared.checkTokenIsValid()
                    //        result(result_)
                } else if (call.method == "deleteUserByUserId") {
                    if (arguments == null || arguments["user_id"] == null) {
                        result.error("INPUT_DATA_INVALID", "userId not found", null)
                    } else {
                        val userId = arguments["user_id"] as String
                        val resultCode = SdkNative.getInstance().deleteUserByUserId(userId)
                        Log.d("deleteUser Result User ", " $userId $resultCode")
                        result.success(resultCode)
                    }
                } else if (call.method == "getListUser") {
                    val resultList = SdkNative.getInstance().userListInJson
                    if (resultList != null) {
                        val resultStr = String(resultList)
                        result.success(resultStr)
                    }

                } else {
                    //        result(FlutterMethodNotImplemented)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}