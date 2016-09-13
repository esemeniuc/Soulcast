//
//  PushPermissionVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-05.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit


class PushPermissionVC: PermissionVC {
  let pushTitle = "Push Notification"
  let pushDescription = "To be able to listen to those around you, we need to be able to send you push notifications"
  
  init() {
    super.init(title: pushTitle, description: pushDescription) {
      AppDelegate.registerForPushNotifications(UIApplication.sharedApplication())
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  static var hasPushPermission: Bool {
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      return true
    #endif

    return UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
  }
  
  
  static func getInstance(vc:UIViewController?) -> PushPermissionVC? {
    if vc is PushPermissionVC {
      return vc as? PushPermissionVC
    }
    if vc == nil {
      return nil
    }
    var hypothesis:PushPermissionVC? = nil
    for eachChildVC in (vc?.childViewControllers)! {
      if let found = getInstance(eachChildVC) {
        hypothesis = found
      }
    }
    return hypothesis
  }

  
}