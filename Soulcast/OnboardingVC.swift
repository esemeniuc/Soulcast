

import Foundation
import UIKit

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
    let pushPermissionVC = PermissionVC(
    type: Permission.Push) {
      AppDelegate.registerForPushNotifications(UIApplication.sharedApplication())
    }
    let audioPermissionVC = PermissionVC(
    type: Permission.Microphone) {
      //
    }
    let locationPermissionVC = PermissionVC(
    type: Permission.Location) {
      //
    }
    permissionVCs.append(pushPermissionVC)
    permissionVCs.append(audioPermissionVC)
    permissionVCs.append(locationPermissionVC)
    
    for eachVC in permissionVCs {
      eachVC.delegate = self
    }
    
    pushPermissionVC.view.backgroundColor = UIColor.blueColor()
    audioPermissionVC.view.backgroundColor = UIColor.brownColor()
    locationPermissionVC.view.backgroundColor = UIColor.cyanColor()
  }
  
  func setupPageVC() {
    //TODO
    pageVC.pages = permissionVCs
    addChildViewController(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMoveToParentViewController(self)
    pageVC.view.backgroundColor = UIColor.yellowColor()
  }
  
}

extension OnboardingVC: PermissionVCDelegate {
  func didGetPermission(type:Permission) {
    //TODO: scroll to next
    pageVC.scrollToVC(pageVC.currentIndex + 1, direction: .Forward)
  }
}

