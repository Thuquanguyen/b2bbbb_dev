//
//  ResultCode.h
//  MkOtpLibSdk_v1.1.0
//
//  Created by Hiep Pham on 10/28/16.
//  Copyright © 2016 HiepPham. All rights reserved.
//

/*!
 * @discussion These are all result types
 */
#import <Foundation/Foundation.h>

@interface ResultCode : NSObject

/*!
 * @typedef Result types
 * @brief A list of result types.
 * @constant ACT_SUCCESS Success
 * @constant ACT_INCORRECT_ACTIVATION_CODE Incorrect activation code
 * @constant ACT_EXPIRED_ACTIVATION_CODE Activation code expired
 * @constant ACT_URL_INVALID Url invalid
 * @constant ACT_FAIL Fail
 */
typedef enum {
    /// Success
    ACT_SUCCESS = 0,
    
    /// Incorrect activation code
    ACT_INCORRECT_ACTIVATION_CODE = 91,
    
    /// The activation code is expired
    ACT_EXPIRED_ACTIVATION_CODE = 90,
    
    /// The activation code is expired
    ACT_EXCEEDED_RETRY_COUNT_OF_5 = 89,
    
    /// The url is invalid
    ACT_URL_INVALID = 92,
    
    /// The activation code is already used
    ACT_ACTIVATION_CODE_USED = 97,
    
    /// Request fail result
    ACT_FAIL = 93,
    
    /// connection error
    CONNECTION_ERROR_COULD_NOT_CONNECT = 7,
    
    /// Connection lost
    CONNECTION_TIMEDOUT = 28,
    
    /// Device Rooted
    ACT_DEVICE_ROOTED = 94,
    
    /// Sync OTP exceed in timestep
    ACT_SYNC_OTP_EXCEEDED = 205
} ResultCodes;


@end
