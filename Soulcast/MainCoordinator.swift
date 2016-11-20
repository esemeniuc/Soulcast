//
//  MainCoordinator.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject {
  var mainVC: MainVC?
  private var navVC: UINavigationController
  var incomingVC:IncomingCollectionVC!
  let improveVC = ImproveVC()
  var onboardingVC: OnboardingVC?
  
  var rootVC:UIViewController {
    return HistoryVC()
    return navVC
  }
  
  
  override init() {
    if Receptionist.needsOnboarding() {
      onboardingVC = OnboardingVC()
      navVC = UINavigationController(rootViewController: onboardingVC!)
      super.init()
      onboardingVC!.delegate = self
    } else {
      mainVC = MainVC()
      navVC = UINavigationController(rootViewController: mainVC!)
      super.init()
      mainVC!.delegate = self
    }
    navVC.delegate = self
  }
  
  

}

extension MainCoordinator: UINavigationControllerDelegate {
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    switch viewController {
      case is MainVC:
      navigationController.navigationBarHidden = true
    case is ImproveVC:
      navigationController.navigationBarHidden = false
    default: break
    }
  }
}

extension MainCoordinator: OnboardingVCDelegate {
  func transitionToMainVC() {
    let window = UIApplication.sharedApplication().keyWindow!
    if window.rootViewController is MainVC {
      return
    }
    if mainVC == nil {
      mainVC = MainVC()
    }
    mainVC!.view.alpha = 0
    window.backgroundColor = UIColor.whiteColor()
    navVC.viewControllers = [mainVC!]
    UIView.animateWithDuration(1, animations: {
      self.mainVC!.view.alpha = 1
    })
    
  }
}

extension MainCoordinator: MainVCDelegate {
  
  func promptImprove() {
    improveVC.delegate = self
    navVC.pushViewController(improveVC, animated: true)
  }

}


extension MainCoordinator: ImproveVCDelegate {
  func didFinishGettingImprove() {
    navVC.popToRootViewControllerAnimated(true)
  }
}


extension MainCoordinator: IncomingCollectionVCDelegate {
  func didRunOutOfSouls() {
    dismissIncomingVC()
  }
  func presentIncomingVC() {
    if incomingVC == nil {
      incomingVC = IncomingCollectionVC()
    }
    incomingVC.delegate = self
    incomingVC.view.frame = IncomingCollectionVC.beforeFrame
    navVC.presentViewController(incomingVC, animated: false) {
      //
    }
    incomingVC.view.userInteractionEnabled = true
    UIView.animateWithDuration(0.67) {
      self.incomingVC.view.frame = IncomingCollectionVC.afterFrame
    }
  }
  func dismissIncomingVC() {
    incomingVC.willMoveToParentViewController(nil)
    incomingVC.view.userInteractionEnabled = false
    UIView.animateWithDuration(0.67, animations: {
      self.incomingVC.view.frame = IncomingCollectionVC.beforeFrame
    }){ completed in
      self.incomingVC.view.removeFromSuperview()
      self.incomingVC.removeFromParentViewController()
    }
    
  }
}

