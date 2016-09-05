

import Foundation
import UIKit



struct PermissionRequest {
  static let push = "Push Notification"
  static let pushDescription = "To be able to listen to those around you, we need to be able to send you push notifications"
  
  static let audio = "Microphone Access"
  static let audioDescription = "To be able to cast your voice to those around you, we need microphone access"
  
  static let location = "Location Permission"
  static let locationDescription = "This is a location-based app. We need your location so that you can catch souls around you"
  let type: String
  let description: String
  
}

class OnboardingVC: UIViewController {
  
  let pageVC = JKPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  var permissionVCs = [PermissionVC]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    setupPermissionVCs()
    setupPageVC()
  }
  
  static func getInstance(vc:UIViewController?) -> OnboardingVC? {
    if vc is OnboardingVC {
      return vc as? OnboardingVC
    }
    if vc == nil {
      return nil
    }
    var hypothesis:OnboardingVC? = nil
    for eachChildVC in (vc?.childViewControllers)! {
      if let found = getInstance(eachChildVC) {
        hypothesis = found
      }
    }
    return hypothesis
  }
  
  func setupPermissionVCs() {
    let pushPermissionVC =
      PermissionVC(request: PermissionRequest(type: PermissionRequest.push, description: PermissionRequest.pushDescription), behavior: pushPermissionBehavior())
    let audioPermissionVC =
      PermissionVC(request: PermissionRequest(type: PermissionRequest.audio, description: PermissionRequest.audioDescription), behavior: audioPermissionBehavior())
    let locationPermissionVC =
      PermissionVC(request: PermissionRequest(type: PermissionRequest.location, description: PermissionRequest.locationDescription), behavior: locationPermissionBehavior())

    permissionVCs.append(pushPermissionVC)
    permissionVCs.append(audioPermissionVC)
    permissionVCs.append(locationPermissionVC)
    
    pushPermissionVC.view.backgroundColor = UIColor.blueColor()
    audioPermissionVC.view.backgroundColor = UIColor.brownColor()
    locationPermissionVC.view.backgroundColor = UIColor.cyanColor()
  }
  
  func pushPermissionBehavior() -> PermissionBehavior {
    return
      PermissionBehavior(requestAction: {
          AppDelegate.registerForPushNotifications(UIApplication.sharedApplication())
        }, successAction: self.gotPushPermission,
           failAction: {
          //TODO:
      })
  }
  
  func gotPushPermission() {
    self.pageVC.scrollToVC(self.pageVC.currentIndex + 1, direction: .Forward)

  }
  
  func audioPermissionBehavior() -> PermissionBehavior {
    return
      PermissionBehavior(requestAction: {
        //
        }, successAction: {
          self.pageVC.scrollToVC(self.pageVC.currentIndex + 1, direction: .Forward)
        }, failAction: {
          //
      })
  }
  
  func locationPermissionBehavior() -> PermissionBehavior {
    return
      PermissionBehavior(requestAction: {
        //
        }, successAction: {
          //
        }, failAction: {
          //
      })
  }
  
  func setupPageVC() {
    pageVC.pages = permissionVCs
    addChildViewController(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMoveToParentViewController(self)
    pageVC.view.backgroundColor = UIColor.yellowColor()
  }
  
}

