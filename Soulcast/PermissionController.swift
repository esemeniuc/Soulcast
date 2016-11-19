//
//  PermissionController.swift
//  Soulcast
//
//  Created by June Kim on 2016-10-20.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class PermissionController {
  
  let locationManager = CLLocationManager()
  private static let hasAudioPermissionKey = "hasAudioPermission"

  
  static var hasLocationPermission:Bool {
    get {
      let status = CLLocationManager.authorizationStatus()
      return status == .AuthorizedAlways || status == .AuthorizedWhenInUse
    }
  }
  
  
  static var hasPushPermission: Bool {
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      return true
    #endif
    
    return UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
  }
  
  static var hasAudioPermission: Bool {
    get {
      if let status = NSUserDefaults.standardUserDefaults().valueForKey(hasAudioPermissionKey) as? Bool {
        return status
      } else {
        return false
      }
    }
    set {
      NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: hasAudioPermissionKey)
    }
  }
  
  
}
