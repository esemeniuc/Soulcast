

import Foundation
import UIKit

protocol OnboardingVCDelegate: class {
  func transitionToMainVC()
}

class OnboardingVC: UIViewController {
  
  let pageVC = JKPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  var eachPageVCs = [UIViewController]()
  weak var delegate: OnboardingVCDelegate?
//  private let pushPermissionVC = PushPermissionVC()
//  private let audioPermissionVC = AudioPermissionVC()
//  private let locationPermissionVC = LocationPermissionVC()
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    setupEachPageVCs()
    setupPageVC()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
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
    pageVC.didMove(toParentViewController: self)
    pageVC.disableScroll()
  }
  
  func waitAndScrollFrom(_ vc:UIViewController) {
    let delayTime = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      if vc is LocationPermissionVC {
        self.delegate?.transitionToMainVC()
      } else {
        let index = self.pageVC.currentIndex
        self.pageVC.scrollToVC(index + 1, direction: .forward)
      }
    }
  }
}


extension OnboardingVC: PermissionVCDelegate {
  func gotPermission(_ vc: PermissionVC) {
    //FIXME: gets called multiple times per permission. fix
    print("gotPermission")
    //if the permission matches the current one
    if pageVC.currentVC == vc {
      //wait
      waitAndScrollFrom(vc)
    }
  }
  
  func deniedPermission(_ vc: PermissionVC) {
    delegate?.transitionToMainVC()
  }
}

extension OnboardingVC: EulaVCDelegate {
  func didTapOKButton(_ vc:EulaVC) {
    waitAndScrollFrom(vc)
  }
}

