//
//  AppDelegate.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-22.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import UIKit
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let tempSoulCatcher = SoulCatcher()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    if window == nil {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
    }
    window?.rootViewController = MainVC()
    self.window?.makeKeyAndVisible()
    registerForPushNotifications(application)
    setAWSLoggingLevel()
//    tester.testAllTheThings()
    
    return true
  }
  
  func setAWSLoggingLevel() {
    AWSLogger.defaultLogger().logLevel = .Warn
  }
  

}

extension AppDelegate { //push
  
  func registerForPushNotifications(application: UIApplication) {
    let notificationSettings = UIUserNotificationSettings(
      forTypes: [.Badge, .Sound, .Alert], categories: nil)
    application.registerUserNotificationSettings(notificationSettings)
  }
  
  func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    if notificationSettings.types != .None {
      application.registerForRemoteNotifications()
    }
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let tokenString = AppDelegate.tokenString(from: deviceToken)
    Device.localDevice.token = tokenString
    print("Token String: \(tokenString)")
  }
  
  static func tokenString(from deviceToken:NSData) -> String{
    let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
    var tokenString = ""
    for i in 0..<deviceToken.length {
      tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    return tokenString
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("Failed to register:", error)
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    let aps = userInfo["aps"] as! [String: AnyObject]
    print("didReceiveRemoteNotification! aps: ")
    for eachItem in aps {
      print(eachItem)
    }
    //TODO: present incomingSoul
    
    tempSoulCatcher.catchSoul(userInfo)
  }
  

}

extension AppDelegate { //aws
  
  func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
    
    AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
  }
  
}

extension AppDelegate { //etc

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

}