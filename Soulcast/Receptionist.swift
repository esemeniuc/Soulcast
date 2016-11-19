//
//  Receptionist.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-09.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit


class Receptionist: NSObject {
  
  private static let hasLaunchedKey = "hasLaunchedOnce"
  
  private static var hasLaunchedBefore: Bool {
    get {
      if let hasLaunched = NSUserDefaults.standardUserDefaults().valueForKey(hasLaunchedKey) as? Bool {
        return hasLaunched
      } else {
        return false
      }
    } set {
      NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: hasLaunchedKey)
    }
  }
  
  class func needsOnboarding() -> Bool {
    if !hasLaunchedBefore {
      hasLaunchedBefore = true
      return true
    }
    if !PermissionController.hasLocationPermission {
      return true
    }
    return false
  }
  

}
