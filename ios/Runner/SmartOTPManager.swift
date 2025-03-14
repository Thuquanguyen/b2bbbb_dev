//
//  SmartOTPManager.swift
//  Runner
//
//  Created by Kent2508 on 28/07/2021.
//

import Foundation

#if !targetEnvironment(simulator)
class SmartOTPManager {
    static let shared = SmartOTPManager()
    
    lazy var otpSdk = {
        return OtpSdk()
    }()
    
    // SDK functions
    
    func doActive(activeCode: String, tokenPush: String, appId: String, activeUrl: String) -> Int32 {
        return otpSdk.doActive(
            activeCode,
            andTokenPush: tokenPush,
            andAppId: appId,
            andActiveUrl: activeUrl
        )
    }
    
    func loginPIN(_ pin: String) -> Int32 {
        return otpSdk.loginPin(pin)
    }
    
    func setPIN(_ pin: String) {
        otpSdk.setPin(pin)
    }
    
    func changePIN(_ pin: String, _ newPin: String) -> Int32 {
        return otpSdk.changePin(pin, andNewPin: newPin)
    }
    
    func deleteAllExistingTokens() {
        otpSdk.deleteAllExistingTokens()
    }
    
    func checkUserIdExistence(userId: String) -> Bool {
        return otpSdk.checkUserIdExistence(userId)
    }
    
    func deleteUserById(userId: String) -> Bool {
        return otpSdk.deleteUser(byUserId: userId)
    }
    
    func checkAppActivated() -> Bool {
        return otpSdk.checkAppActivated()
    }
    
    func checkAppActivated2(userId: String) -> String {
        let tokenSn = otpSdk.getTokenSn(withUserId: userId)
        let tokenInfo = otpSdk.checkActiveToken2(withUserId: userId, andTokenSN: tokenSn) ?? "{}"
        return tokenInfo
    }
    
    func checkActivatedPIN() -> Bool {
        return otpSdk.checkActivatedPIN()
    }
    
    func getSelectedUserId() -> String {
        return otpSdk.getSelectedUserId()
    }
    
    func getTokenSn() -> String {
        return otpSdk.getTokenSn()
    }
    
    func getCurrentServerTime() -> String {
        return otpSdk.getCurrentServerTime()
    }
    
    func getCRotp(with transactionInfo: String, challengeCode: String) -> String {
        return otpSdk.getCRotp(withTransactionInfo: transactionInfo, andChallengeCode: challengeCode)
    }
    
    func getCRotp(with authType: String, otpType: Int32) -> String {
        return otpSdk.getCRotp(withAuthType: authType, andOtpType: otpType)
    }
    
    func getCRotp(with userId: String, challengeCode: String, otpType: Int32) -> String {
        return otpSdk.getCRotpWithAuthType(withUserId: userId, andChallengeCode: challengeCode, andOtpType: otpType)
    }
    
    func getTimeStep() -> Int32 {
        return otpSdk.getTimeStep()
    }
    
    func getTransactionInfo(with transactionId: String, messageId: String) -> String {
        return otpSdk.getTransactionInfo(withTransactionId: transactionId, andMessageId: messageId)
    }
    
    func doSyncTime() -> Int32 {
        return otpSdk.doSyncTime()
    }
    
    func synchronizeSoftOtp(userId: String) -> Int32 {
        return otpSdk.synchronizeSoftOtp(withUserId: userId)
    }
    
    // customize functions
    
    func clearAll() {
        // first
        deleteAllExistingTokens()
        // and more, if need
        // ...
    }
    
    func isHadActivatedUserOnDevice() -> Bool {
        return checkAppActivated() && !getSelectedUserId().isEmpty
    }
    
    func checkActivatedUserIsLoggingIn(userId: String) -> Bool {
        let ActivatedUserid = getSelectedUserId().lowercased()
        return ActivatedUserid.contains(userId.lowercased())
    }
    
    func getOTP() -> String {
        return otpSdk.getOTPWithAuthType()
    }
    
    func setSelectedUserId(userId: String) {
        otpSdk.setSelectedUserId(userId)
    }
    
//    func getUserListInJson() -> String {
//        if let dataFromStr = otpSdk.getUserListInJson()?.data(using: .utf8, allowLossyConversion: false) {
//            return dataFromStr
//        }nhie
//        return ""
//    }
    
    func decryptQRCode(_ userId: String, _ qrCodeStr: String, _ completion: @escaping ((String?) -> Void)) {
        DispatchQueue.global().async { [weak self] in
            let decryptData = self?.otpSdk.decryptQRCodeData(withUserId: userId, andEncryptedData: qrCodeStr)
            DispatchQueue.main.async {
                completion(decryptData)
            }
        }
    }
    
    
    func checkUserActivatedAnyDevices(userId: String) -> String {
        let tokenSn = getTokenSn()
        let tokenInfo = otpSdk.checkActiveToken2(withUserId: userId, andTokenSN: tokenSn) ?? "{}"
        return tokenInfo
    }
    
    func checkActiveToken2(userId: String) -> String {
        let tokenSn = getTokenSn()
        if let tokenInfo = otpSdk.checkActiveToken2(withUserId: userId, andTokenSN: tokenSn), !tokenInfo.isEmpty {
            return tokenInfo
        }
        return ""
    }
    
}
#endif
