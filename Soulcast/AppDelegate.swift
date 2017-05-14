//
//  AppDelegate.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-22.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import UIKit
import AWSS3
import UserNotifications



let app = UIApplication.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let mainCoordinator = MainCoordinator()
  var tests: VoiceTests!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    launchWindow()
    receive(launchOptions)
    LaunchHelper.launch()
    //    tester.testAllTheThings()
    //tests = VoiceTests()
    
    return true
  }
  
  func launchWindow() {
    if window == nil {
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.backgroundColor = UIColor.white
    }
    window!.rootViewController = mainCoordinator.rootVC
    window!.makeKeyAndVisible()

  }
  
  func receive(_ launchOptions: [AnyHashable: Any]?){
    if let options = launchOptions,
      let userInfo = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:AnyObject],
      let soulHash = userInfo["soulObject"] as? [String:AnyObject] {
      pushHandler.handle(soulHash)
    }
    if let options = launchOptions,
      let userInfo = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:AnyObject],
      let waveHash = userInfo["wave"] as? [String:AnyObject] {
      pushHandler.handleWave(waveHash)
    }
    
  }

}

extension AppDelegate { //push
  
  static func registerForPushNotifications(_ application: UIApplication) {
    if #available(iOS 10, *) { //only support latest version of iOS...
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.badge, .alert, .sound]){ (granted, error) in
        if (!granted) { return }
        application.registerForRemoteNotifications()
      }
    } else {
      application.registerForRemoteNotifications()
    }
  }
  
  func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    if notificationSettings.types != UIUserNotificationType() {
      application.registerForRemoteNotifications()
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenString = AppDelegate.tokenString(from: deviceToken)
    Device.token = tokenString
    ServerFacade.register()
  }
  
  static func tokenString(from deviceToken:Data) -> String{
    let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
    var tokenString = ""
    for i in 0..<deviceToken.count {
      tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    return tokenString
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register:", error)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    if let soulHash = userInfo["soulObject"] as? [String: AnyObject]{
      pushHandler.handle(soulHash)
    } else {
      assert(false, "The soul object isn't recognized!")
    }
    
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    pushHandler.activate()
  }

}
