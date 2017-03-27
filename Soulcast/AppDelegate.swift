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
    tests = VoiceTests()
    
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
    Device.registerWithServer()
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
  

}

extension AppDelegate { //aws
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
  }
  
}

extension AppDelegate { //etc

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    pushHandler.activate()
  }

}
