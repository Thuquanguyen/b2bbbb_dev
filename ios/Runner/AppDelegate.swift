import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBz33Ex77rw_rjmwXkF5ts9EuQac-ExGvM")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let smartOtpChannel = FlutterMethodChannel(name: "com.vpbank/smart_otp_channel", binaryMessenger: controller.binaryMessenger)
    
    let nativeChannel = FlutterMethodChannel(name: "com.vpbank/native_channel", binaryMessenger: controller.binaryMessenger)
    
    smartOtpChannel.setMethodCallHandler({(call: FlutterMethodCall, result:@escaping FlutterResult) -> Void in
        handleFlutterMethodChannel(call: call, result: result)
    })
    
    nativeChannel.setMethodCallHandler({(call: FlutterMethodCall, result:@escaping FlutterResult) -> Void in
        do {
            handleNativeMethodChannel(call: call, result: result)
        } catch {
            result(nil)
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
