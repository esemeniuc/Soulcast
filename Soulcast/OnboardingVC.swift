

import Foundation
import UIKit

protocol OnboardingVCDelegate: class {
  func transitionToMainVC()
}

class OnboardingVC: UIViewController {
  
  let pageVC = JKPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  var eachPageVCs = [UIViewController]()
  weak var delegate: OnboardingVCDelegate?
//  private let pushPermissionVC = PushPermissionVC()
//  private let audioPermissionVC = AudioPermissionVC()
//  private let locationPermissionVC = LocationPermissionVC()
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    setupEachPageVCs()
    setupPageVC()
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //debugColors()
  }

  func setupEachPageVCs() {
    let eulaVC = EulaVC()
    eulaVC.delegate = self
    let locationVC = LocationPermissionVC()
    locationVC.delegate = self
    eachPageVCs = [eulaVC, locationVC]
    
  }
      
  func setupPageVC() {
    pageVC.pages = eachPageVCs
    addChildViewController(pageVC)
    view.addSubview(pageVC.view)
    pageVC.didMoveToParentViewController(self)
    pageVC.disableScroll()
  }
  
  func waitAndScrollFrom(vc:UIViewController) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      if vc is LocationPermissionVC {
        self.delegate?.transitionToMainVC()
      } else {
        let index = self.pageVC.currentIndex
        self.pageVC.scrollToVC(index + 1, direction: .Forward)
      }
    }
  }
}


extension OnboardingVC: PermissionVCDelegate {
  func gotPermission(vc: PermissionVC) {
    //FIXME: gets called multiple times per permission. fix
    print("gotPermission")
    //if the permission matches the current one
    if pageVC.currentVC == vc {
      //wait
      waitAndScrollFrom(vc)
    }
  }
  
  func deniedPermission(vc: PermissionVC) {
    delegate?.transitionToMainVC()
  }
}

extension OnboardingVC: EulaVCDelegate {
  func didTapOKButton(vc:EulaVC) {
    waitAndScrollFrom(vc)
  }
}

