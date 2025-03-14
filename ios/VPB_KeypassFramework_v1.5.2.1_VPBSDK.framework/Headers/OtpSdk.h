//
//  OtpSdk.h
//  MkOtpLibSdk
//
//  Created by VinaPay on 7/5/16.
//  Copyright © 2016 HiepPham. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @discussion The main class of SDK that contains all methods to invoke
 */
@interface OtpSdk : NSObject {
}

-(id)initWithPublicKey:(NSString*)SSL_publicKey privateKey:(NSString*)SSL_privateKey password:(NSString*)SSL_password;

/*!
 * @brief To active app
 * @param activeCode The activation code string that user input at active scene.
 * @param activeUrl The url that point to server
 * @warning activeUrl automatically append "activate2" to make the real active url.
 * @return The ResultCode of activation. Refer to ResultCode document for more detail.
 */
//-(int)doActive:(NSString*)activeCode andActiveUrl:(NSString *)activeUrl;
-(int)doActive:(NSString*)activeCode andTokenPush:(NSString*)tokenPush andAppId:(NSString*)appId andActiveUrl:(NSString *)activeUrl;

/*!
 * @brief To active app using activate3a api (for HDBank)
 *
 */
-(int)doActive3a:(NSString*)activeCode andActiveUrl:(NSString *)activeUrl;

/*!
 * @brief To add push token of older app version (TPBank)
 * @param tokenPush The token push of device
 * @param activeUrl The url address of server
 * @return The ResultCode of activation. Refer to ResultCode document for more detail.
 */
-(int)addPushToken:(NSString*)tokenPush andAppId:(NSString*)appId andActiveUrl:(NSString *)activeUrl;

/*!
 * @brief To get transaction info for signing
 * @return transaction info
 */
-(NSString*) getTransactionInfoWithTransactionId:(NSString*)transactionId andMessageId:(NSString*)messageId;

/*!
 * @brief To check app activated or not
 * @return true if activated else false
 */
-(bool)checkAppActivated;

/*!
 * @brief To check device is jailbroken or not
 * @return true if jailbroken else false
 */
-(bool)checkJailbreak;

/*!
 * @brief To get CR OTP string for transaction signing
 * @param challengeCode The challenge code string that user input at Challenge Code scene.
 * @param transInfo The transaction info with format: FromUser|ToUser|Amount
 * @return The CR OTP string
 */
-(NSString*) getCRotpWithTransactionInfo:(NSString*)transInfo andChallengeCode:(NSString*)challengeCode;

/*!
 * @brief To get CR OTP string in coporate with with PIN, TouchID, FaceID
 * @param challengeCode The challenge code string that user input at Challenge Code scene.
 * @param otpType =1: SHA1, len = 6; =2: SHA256, len = 10; =3: SHA512
 * @return The CR OTP string
 */
-(NSString*) getCRotpWithAuthTypeWithUserId:(NSString*)userId andChallengeCode:(NSString*)challengeCode andOtpType:(int)otpType;

/*!
 * @brief To get CR OTP string in coporate with with PIN, TouchID, FaceID (default user)
 * @param challengeCode The challenge code string that user input at Challenge Code scene.
 * @param otpType =1: SHA1, len = 6; =2: SHA256, len = 10; =3: SHA512
 * @return The CR OTP string
 */
-(NSString*) getCRotpWithAuthType:(NSString*)challengeCode andOtpType:(int)otpType;

/*!
 * @brief To get OTP string in auth methods: PIN/TouchID/FaceID
 * @return The OTP string
 */
-(NSString*) getOTPWithAuthTypeWithUserId:(NSString*)userId;

/*!
 * @brief To get OTP string in auth methods: PIN/TouchID/FaceID (default user)
 * @return The OTP string
 */
-(NSString*) getOTPWithAuthType;

/*!
 * @brief To request to server to get the difference of time. This function used to use when the time of device has changed.
 * @return The ResultCode. Refer to ResultCode document for more detail.
 */
-(int)doSyncTime;

/*!
 * @brief In background, update version of app to server
 * @return The ResultCode. Refer to ResultCode document for more detail.
 */
-(int)doUpdateVersion:(NSString*)version;

/*!
 * @brief To get current time on server.
 * @return The string of current time on server based on DateTime format "dd-MM-YYYY HH:mm:ss"
 */
-(NSString*)getCurrentServerTime;

/*!
 * @brief To get serial number of current mobile device on OTP system.
 * @return The string of serial number
 */
-(NSString*)getTokenSnWithUserId:(NSString*)userId;

/*!
 * @brief To get serial number of current mobile device on OTP system. (default user)
 * @return The string of serial number
 */
-(NSString*)getTokenSn;

/*!
 * @brief To get difference of time between current device and server.
 * @return The difference of time in second.
 */
-(NSInteger)getTimeoffset;

/*!
 * @brief To encrypt the pin number
 */
-(NSString*)encryptPinNumber: (NSString*)pinNumber;

/*!
 * @brief To set Pin number
 */
-(void)setPin: (NSString*)pinNumber;

/*!
 * @brief To login using Pin number
 * @return The ResultCode of login, 21: wrong pin, 0: success
 */
-(int)loginPin: (NSString*)pinNumber;

/*!
 * @brief To change Pin number
 * @return The ResultCode of changePin, 21: wrong pin, 1: success
 */
-(int)changePin: (NSString*)curPin andNewPin:(NSString*)newPin;

/*!
 * @brief To check app is using Pin or not
 */
-(bool)checkUsingPin;

/*!
 * @brief To set TimeStep to calculate OTP
 */
-(void) setTimeStep:(int)timeStep;

/*!
 * @brief To get TimeStep
 */
-(int) getTimeStep;

/*!
 * @brief To check if device support TouchID
 */
-(bool) checkDeviceSupportTouchID;

/*!
 * @brief To check if device support FaceID
 */
-(bool) checkDeviceSupportFaceID;

/*!
 * @brief To authenticate using TouchID or FaceID
 */
-(void) authBiometricWithReason:(NSString*)reason andFallbackTitle:(NSString*)fallbackTitle andSuccess:(void (^)()) successHandler andFailure: (void (^)(long errorCode)) failureHandler;

/*!
 * @brief To activate TouchID authentication
 */
-(bool) activateBioTouchID;

/*!
 * @brief To activate FaceID authentication
 */
-(bool) activateBioFaceID;

/*!
 * @brief To activate PINCODE authentication
 */
-(bool) activatePINCODE;

/*!
 * @brief To check if currently activated TouchID
 */
-(bool) checkActivatedBioTouchID;

/*!
 * @brief To check if currently activated FaceID
 */
-(bool) checkActivatedBioFaceID;

/*!
 * @brief To check if currently activated PIN
 */
-(bool) checkActivatedPIN;

/*!
 * @brief To get the app's latest iOS version
 */
-(NSString*) getAppLatestVersion: (NSString*)serverUrl andAppVersion:(NSString*)appVersion;

// 1.5.0 NEW METHODS
/*!
 * @brief To get the current userId selected
 */
-(NSString*) getSelectedUserId;

/*!
 * @brief To set the current userId selected
 */
-(void) setSelectedUserId:(NSString*)userId;

/*!
 * @brief To get list of current tokens
 */
-(NSString*) getUserListInJson;

/*!
 * @brief To delete token by userId
 */
-(bool) deleteUserByUserId:(NSString*)userId;

/*!
 * @brief To rename token by userId
 */
-(bool) changeUserNameWithUserId:(NSString*)userId andNewName:(NSString*)userName;

-(bool) changeCustomerNameWithUserId:(NSString*)userId andNewName:(NSString*)customerName;

-(bool) checkUserIdExistence:(NSString*)userId;

//#ifdef TPBANK
/*!
 * @brief for TPBank v1.8: To check if app already using PIN or not
 */
-(bool) checkIsUsingPinSDKv132;

/*!
 * @brief for TPBank v1.8: To check if app already activated
 */
-(bool) checkExistOldSDKVersion;

/*!
 * @brief for TPBank v1.8: To check and convert Pin & TokenData
 */
-(bool) checkConvertTokenDataSdk132WithPin:(NSString*)pinNumber;
//#endif

//#if ACB
/*!
 * @brief for ACB SDKv1.5.0: To check if app already activated
 */
-(bool) checkExistOldSDKVersion150;

/*!
 * @brief for ACB SDKv1.5.0: để kiểm tra nếu ko có userID, customerTypeID, customerName thì mặc định add thêm với giá trị default
 */
-(bool) checkUpdateUserInfoWithTokenSN:(NSString*)tokenSN andAppVersion:(NSString*)appVersion;

//-(bool) checkValidTokenDataFromV150;

/*!
 * @brief for ACB Safekey v2.0.0: To check and convert TokenData from old version using SDKv1.5.0
 */
-(bool) checkConvertTokenDataSdk150WithPin:(NSString*)pinNumber;

/*!
 * @brief for ACB Safekey v2.0.0: To check and update UserInfo when upgraded from old version using SDKv1.5.0
 */
-(bool) checkUpdateUserInfov150WithAppVersion: (NSString*)appVersion;

/*!
 * @brief To login using Pin number for ACBSafeKey SDKv1.5.0
 * @return The ResultCode of login, 21: wrong pin, 1: success
 */
-(int)loginPinv150: (NSString*)pinNumber;
//#endif

/*!
 * @brief for TPBank v1.8: To check if push activated when upgraded to latest version
 */
-(bool) checkPushActivated;

/*!
 * @brief for TPBank v1.8: To update push token
 */
-(int) updatePushToken:(NSString*)currentPushToken andNewPushToken:(NSString*)newPushToken;

/*!
 * @brief To remove user on Keypass server
 */
-(int) removeUserOnKeypassServer:(NSString*)userId andTokenID:(NSString*)tokenSN andPushToken:(NSString*)pushToken;

/*!
 * @brief to get 2 Advance OTPs with CR = 000000 for sync with default userId
 */
-(NSString*) getAdvanceOTPForSync;

/*!
 * @brief to get 2 Basic OTPs for sync with default userId
 */
-(NSString*) getBasicOTPForSync;

/*!
 * @brief to add new token (Basic, Advance) to existing token. Basic uses null pushToken
 */
-(int) addNewToken:(NSString*)tokenId andActivationCode:(NSString*)activationCode andPushToken:(NSString*)pushToken andAppId:(NSString*)appId andActiveUrl:(NSString *)activeUrl;

/*!
 * @brief to get data from QRCode string
 */
-(NSString*) decryptQRCodeDataWithUserId:(NSString*)userId andEncryptedData:(NSString*)qrCodeString;

/*!
 * @brief to get customerTypeId with userId
 */
-(int) getCustomerTypeIdWithUserId:(NSString*)userId;

/*!
 * @brief to get customerName with userId
 */
-(NSString*) getCustomerNameWithUserId:(NSString*)userId;

/*!
 * @brief to get userName with userId
 */
-(NSString*) getUserNameWithUserId:(NSString*)userId;

/*!
 * @brief to get AidVersion of userId
 */
-(NSString*) getAidVersionWithUserId:(NSString*)userId;

/*!
 * @brief to get 2 Advance OTPs with CR = 000000 for sync with input userId
 */
-(NSString*) getAdvanceOTPForSyncWithUserId:(NSString*)userId;

/*!
 * @brief for Vietinbank, delete all activated tokens for "Forget the PIN" function
 */
-(bool) deleteAllExistingTokens;

/*!
 * @brief to encrypt & save wrong PIN number
 */
-(bool) encryptAndSaveWrongPinNumber:(int)wrongPinCount;

/*!
 * @brief to get wrong PIN number
 */
-(int) getWrongPinNumber;

/*!
 * @brief to synchronize Advance & Basic OTP, return the resultCode
 */
-(int) synchronizeSoftOtpWithUserId:(NSString*)userId;

/*!
 * @brief to get label list from server (transactionTypeID, destinationTypeID)
 */
-(NSString*) getLabelList;

-(int) checkActiveToken;

-(NSString*) checkActiveToken2WithUserId:(NSString*)userId andTokenSN:(NSString*)tokenSN;

@end
