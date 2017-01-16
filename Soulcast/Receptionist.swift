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
  
  fileprivate static let hasLaunchedKey = "hasLaunchedOnce"
  
  fileprivate static var hasLaunchedBefore: Bool {
    get {
      if let hasLaunched = UserDefaults.standard.value(forKey: hasLaunchedKey) as? Bool {
        return hasLaunched
      } else {
        return false
      }
    } set {
      UserDefaults.standard.setValue(newValue, forKey: hasLaunchedKey)
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
