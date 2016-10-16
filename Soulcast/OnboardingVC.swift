

import Foundation
import UIKit



class OnboardingVC: UIViewController {
  
  let pageVC = JKPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  var eachPageVCs = [UIViewController]()
  
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
        self.transitionToMainVC()
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
  
  func transitionToMainVC() {
    let window = UIApplication.sharedApplication().keyWindow!
    if window.rootViewController is MainVC {
      return
    }
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
    self.transitionToMainVC()
  }
}

extension OnboardingVC: EulaVCDelegate {
  func didTapOKButton(vc:EulaVC) {
    waitAndScrollFrom(vc)
  }
}

