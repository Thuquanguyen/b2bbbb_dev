//
//  NativeHandler.swift
//  Runner
//
//  Created by Tuan Dinh on 15/09/2021.
//

import Foundation
import IOSSecuritySuite

func handleNativeMethodChannel(call: FlutterMethodCall, result:@escaping FlutterResult) {
    if call.method == "isThisCompromised" {
        let jailbreakStatus = IOSSecuritySuite.amIJailbrokenWithFailMessage()
        if jailbreakStatus.jailbroken {
            print("This device is compromised")
            print("Because: \(jailbreakStatus.failMessage)")
            result(true)
        } else {
            print("This device is safe")
            result(false)
        }
    } else {
      result(FlutterMethodNotImplemented)
      return
    }
}
