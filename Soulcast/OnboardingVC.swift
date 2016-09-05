

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
    view.backgroundColor = UIColor.whiteColor()
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
    //if the permission matches the current one
    if pageVC.currentVC == vc {
      //wait
      let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.35 * Double(NSEC_PER_SEC)))
      dispatch_after(delayTime, dispatch_get_main_queue()) {
        self.pageVC.scrollToVC(self.pageVC.currentIndex + 1, direction: .Forward)
      }
      
    }
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
