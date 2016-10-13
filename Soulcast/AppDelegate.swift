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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    makeWindow()
    receive(launchOptions)
    window?.rootViewController = Receptionist.launchingViewController
//    window?.rootViewController = MainVC()
//        window?.rootViewController = MockingVC()
//        window?.rootViewController = OnboardingVC()

//    tester.testAllTheThings()
    self.window?.makeKeyAndVisible()
    setAWSLoggingLevel()
    return true
  }
  
  func makeWindow() {
    if window == nil {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)
      window?.backgroundColor = UIColor.whiteColor()
    }
  }
  
  func receive(launchOptions: [NSObject:AnyObject]?){
    if let options = launchOptions{
      //what is the format for launch options?
      if let soulObject = options["soulObject"] as? [String: AnyObject] {
        MainVC.getInstance((window?.rootViewController)!)?.receiveRemoteNotification(soulObject)
      }
    }
  }
  
  func setAWSLoggingLevel() {
    AWSLogger.defaultLogger().logLevel = .Warn
  }
  

}

extension AppDelegate { //push
  
  static func registerForPushNotifications(application: UIApplication) {
    if #available(iOS 10, *) { //only support latest version of iOS...
      UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Badge, .Alert, .Sound]){ (granted, error) in
        if (!granted) { return }
        application.registerForRemoteNotifications()
        if let appDelegate = application.delegate ,
          let window = appDelegate.window,
          let rootVC = window!.rootViewController,
          let pushVC = PushPermissionVC.getInstance(rootVC){
          pushVC.gotPermission()
        }
      }
    }
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
    //send a message to the onboarding view controller in the view controller tree
    PushPermissionVC.getInstance((window?.rootViewController)!)?.gotPermission()
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
    PushPermissionVC.getInstance((window?.rootViewController)!)?.deniedPermission()
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    if let aps = userInfo["aps"] as? [String: AnyObject] {
      print("didReceiveRemoteNotification! aps: ")
      for eachItem in aps {
        print(eachItem)
      }
    }
    if let soulObject = userInfo["soulObject"] as? [String: AnyObject]{
      MainVC.getInstance((window?.rootViewController)!)?.receiveRemoteNotification(soulObject)
    }
    //TODO: present incomingSoul
    
    
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
