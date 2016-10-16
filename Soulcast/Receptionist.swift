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
  private static var hasPushPermission: Bool {
    return PushPermissionVC.hasPushPermission
  }
  private static var hasAudioPermission: Bool {
    return AudioPermissionVC.hasAudioPermission
  }
  private static var hasLocationPermission: Bool {
    return LocationPermissionVC.hasLocationPermission
  }
  
  class var launchingViewController: UIViewController {
    if needsOnboarding() {
      return OnboardingVC()
    } else {
      return MainVC()
    }
  }
  
  private class func needsOnboarding() -> Bool {
    if !hasLaunchedBefore {
      hasLaunchedBefore = true
      return true
    }
    if !hasLocationPermission { //!hasPushPermission || !hasAudioPermission ||
      return true
    }
    return false
  }
  

}
