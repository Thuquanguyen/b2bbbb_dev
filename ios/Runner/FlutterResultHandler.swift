//
//  FlutterResultHandler.swift
//  Runner
//
//  Created by Kent2508 on 28/07/2021.
//

import Foundation

func handleFlutterMethodChannel(call: FlutterMethodCall, result:@escaping FlutterResult) {
    #if targetEnvironment(simulator)
    result(FlutterError(code: "ENVIRONMENT_INVALID", message: "SmartOTP should not work on Simulator", details: nil))
    #else

    if call.method == "doActive" {
        guard let arguments = call.arguments as? [String: Any], let activeCode = arguments["active_code"] as? String, let pushToken = arguments["push_token"] as? String, let appId = arguments["app_id"] as? String, let activeUrl = arguments["active_url"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let resultCode = SmartOTPManager.shared.doActive(activeCode: activeCode, tokenPush: pushToken, appId: appId, activeUrl: activeUrl)
        result(resultCode)
    }
    else if call.method == "deleteUserByUserId" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let code = SmartOTPManager.shared.deleteUserById(userId: userId)
        result(code)
    }
    else if call.method == "deleteAllExistingTokens" {
        SmartOTPManager.shared.deleteAllExistingTokens()
        result(nil)
    }
    else if call.method == "checkUserIdExistence" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let resultValue = SmartOTPManager.shared.checkUserIdExistence(userId: userId)
        result(resultValue)
    }
    else if call.method == "checkAppActivated" {
        let appActivated = SmartOTPManager.shared.checkAppActivated()
        result(appActivated)
    }
    else if call.method == "checkAppActivated2" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let appActivated = SmartOTPManager.shared.checkAppActivated2(userId: userId)
        result(appActivated)
    }
    else if call.method == "checkActivatedPIN" {
        let pinActivated = SmartOTPManager.shared.checkActivatedPIN()
        result(pinActivated)
    }
    else if call.method == "getSelectedUserId" {
        let userId = SmartOTPManager.shared.getSelectedUserId()
        result(userId)
    }
    else if call.method == "getTokenSn" {
        let token = SmartOTPManager.shared.getTokenSn()
        result(token)
    }
    else if call.method == "getCurrentServerTime" {
        let timeStr = SmartOTPManager.shared.getCurrentServerTime()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy HH':'mm':'ss"
        let date = dateFormatter.date(from: timeStr)
        let time = Int32((date?.timeIntervalSince1970 ?? 0))
        result(time)
    }
    else if call.method == "getCRotpWithTransaction" {
        guard let arguments = call.arguments as? [String: Any], let transactionInfo = arguments["transaction_info"] as? String, let challengeCode = arguments["challenge_code"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "Transaction info not found", details: nil))
            return
        }
        let transInfo = SmartOTPManager.shared.getCRotp(with: transactionInfo, challengeCode: challengeCode)
        result(transInfo)
    }
    else if call.method == "getTimeStep" {
        let timeStep = SmartOTPManager.shared.getTimeStep()
        result(timeStep)
    }
    else if call.method == "getTransactionInfo" {
        guard let arguments = call.arguments as? [String: Any], let transactionId = arguments["transaction_id"] as? String, let messageId = arguments["message_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "Transaction info not found", details: nil))
            return
        }
        let transInfo = SmartOTPManager.shared.getTransactionInfo(with: transactionId, messageId: messageId)
        result(transInfo)
    }
    else if call.method == "doSyncTime" {
        DispatchQueue.global().async {
            let resultCode = SmartOTPManager.shared.doSyncTime()
            result(resultCode)
        }
    }
    else if call.method == "synchronizeSoftOtp" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        DispatchQueue.global().async {
            let resultCode = SmartOTPManager.shared.synchronizeSoftOtp(userId: userId)
            result(resultCode)
        }
    }
    else if call.method == "clearAll" {
        SmartOTPManager.shared.clearAll()
        result(nil)
    }
    else if call.method == "loginPIN" {
        guard let arguments = call.arguments as? [String: Any], let pin = arguments["pin"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "PIN must be not empty", details: nil))
            return
        }
        let code = SmartOTPManager.shared.loginPIN(pin)
        result(code)
    }
    else if call.method == "changePIN" {
        guard let arguments = call.arguments as? [String: Any], let pin = arguments["pin"] as? String, let newPin = arguments["new_pin"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "PIN must be not empty", details: nil))
            return
        }
        SmartOTPManager.shared.changePIN(pin, newPin)
        result(nil)
    }
    else if call.method == "setPIN" {
        guard let arguments = call.arguments as? [String: Any], let pin = arguments["pin"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "PIN must be not empty", details: nil))
            return
        }
        SmartOTPManager.shared.setPIN(pin)
        result(nil)
    }
    else if call.method == "setSelectedUserId" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let resultCode = SmartOTPManager.shared.checkUserIdExistence(userId: userId)
        if (resultCode) {
            SmartOTPManager.shared.setSelectedUserId(userId: userId)
        }
        result(nil)
    }
    else if call.method == "isHadActivatedUserOnDevice" {
        let result_ = SmartOTPManager.shared.isHadActivatedUserOnDevice()
        result(result_)
    }
    else if call.method == "getOTP" {
        let result_ = SmartOTPManager.shared.getOTP()
        result(result_)
    }
    else if call.method == "checkActivatedUserIsLoggingIn" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let result_ = SmartOTPManager.shared.checkActivatedUserIsLoggingIn(userId: userId)
        result(result_)
    }
    else if call.method == "checkUserActivatedAnyDevices" {
        guard let arguments = call.arguments as? [String: Any], let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        let result_ = SmartOTPManager.shared.checkUserActivatedAnyDevices(userId: userId)
        result(result_)
    }
    else if call.method == "decryptQRCodeDataWithUserId" {
        guard let arguments = call.arguments as? [String: Any], let qrCodeString = arguments["qr_code_string"] as? String, let userId = arguments["user_id"] as? String else {
            result(FlutterError(code: "INPUT_DATA_INVALID", message: "UserId not found", details: nil))
            return
        }
        SmartOTPManager.shared.decryptQRCode(userId, qrCodeString) { decryptData in
            result(decryptData)
        }
    }
    //Native Channel
    //
    else {
      result(FlutterMethodNotImplemented)
      return
    }
    
    #endif
}
