

import Foundation
import UIKit



class OnboardingVC: UIViewController {
  
  let pageVC = JKPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  var permissionVCs = [PermissionVC]()
  
  private let pushPermissionVC = PushPermissionVC()
  private let audioPermissionVC = AudioPermissionVC()
  private let locationPermissionVC = LocationPermissionVC()
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.blackColor()
    setupPermissionVCs()
    setupPageVC()
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //debugColors()
  }
    
  func setupPermissionVCs() {
    
    permissionVCs = [pushPermissionVC, audioPermissionVC, locationPermissionVC]
    
    for eachPermissionVC in permissionVCs {
      eachPermissionVC.delegate = self
    }
    
  }
      
  func setupPageVC() {
    pageVC.pages = permissionVCs
    addChildViewController(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMoveToParentViewController(self)
    pageVC.disableScroll()
  }
  
}


extension OnboardingVC: PermissionVCDelegate {
  func gotPermission(vc: PermissionVC) {
    //FIXME: gets called multiple times per permission. fix
    print("gotPermission")
    //if the permission matches the current one
    if pageVC.currentVC == vc {
      //wait
      let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
      dispatch_after(delayTime, dispatch_get_main_queue()) {
        if vc is LocationPermissionVC {
          self.transitionToMainVC()
        } else {
          let index = self.pageVC.currentIndex
          self.pageVC.scrollToVC(index + 1, direction: .Forward)
        }
      }
      
    }
    
  }
  
  func transitionToMainVC() {
    let window = UIApplication.sharedApplication().keyWindow!
    let mainVC = MainVC()
    mainVC.view.alpha = 0
    window.backgroundColor = UIColor.whiteColor()
    window.rootViewController = mainVC
    window.makeKeyAndVisible()
    UIView.animateWithDuration(1, animations: {
      mainVC.view.alpha = 1
    })

  }
  
  func deniedPermission(vc: PermissionVC) {
    //Push permission always gets denied on simulator
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      if vc is PushPermissionVC {
        gotPermission(vc)
      }
    #endif

    //TODO:
  }
}


extension UIWindow {
  func replaceRootViewControllerWith(replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    let snapshotImageView = UIImageView(image: self.snapshot())
    self.addSubview(snapshotImageView)
    self.rootViewController!.dismissViewControllerAnimated(false, completion: { () -> Void in // dismiss all modal view controllers
      self.rootViewController = replacementController
      self.bringSubviewToFront(snapshotImageView)
      if animated {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
          snapshotImageView.alpha = 0
          }, completion: { (success) -> Void in
            snapshotImageView.removeFromSuperview()
            completion?()
        })
      }
      else {
        snapshotImageView.removeFromSuperview()
        completion?()
      }
    })
  }
}

extension UIView {
  func snapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
    drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }
}