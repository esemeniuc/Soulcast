//
//  MainCoordinator.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, JKPageVCDelegate, UINavigationControllerDelegate, OnboardingVCDelegate, MainVCDelegate, ImproveVCDelegate, HistoryVCDelegate, IncomingCollectionVCDelegate, UIViewControllerTransitioningDelegate, WaveCoordinatorDelegate {
  let pageVC = JKPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  var mainVC: MainVC = MainVC()
  fileprivate var onboardingNavVC: UINavigationController?
  fileprivate var historyNavVC: UINavigationController?
  let historyVC = HistoryVC()
  var incomingVC:IncomingCollectionVC!
  let improveVC = ImproveVC()
  var onboardingVC: OnboardingVC?
  var pages: [UIViewController] = []
  var pushHandleAction:(()->())? = nil
  fileprivate let zoomAnimator = ZoomTransitionAnimationController()
  var waveCoordinator: WaveCoordinator?
  
  var rootVC:UIViewController {
    if onboardingNavVC != nil {
      onboardingNavVC!.title = "onboardingNavVC"
      return onboardingNavVC!
    } else {
      if historyNavVC == nil {
        historyNavVC = UINavigationController(rootViewController: historyVC)
        historyNavVC!.delegate = self
        historyNavVC!.title = "historyNavVC"
        historyNavVC!.setNavigationBarHidden(true, animated: false)
      }
      return pageVC
    }
  }
  
  struct Page {
    static let history = 0
    static let main = 1
  }
  
  override init() {
//    pages = [historyVC, mainVC]
    pages = [UIViewController(), mainVC]
    if Receptionist.needsOnboarding() {
      onboardingVC = OnboardingVC()
      onboardingNavVC = UINavigationController(rootViewController: onboardingVC!)
      super.init()
      onboardingVC!.delegate = self
      onboardingNavVC!.delegate = self
    } else {
      pageVC.initialIndex = 1
      pageVC.pages = pages
      
      super.init()
    }
    pageVC.jkDelegate = self
    pageVC.disableScroll()
    mainVC.delegate = self
    
  }
  
  func scrollToMainVC(_ completion:@escaping ()->()) {
    pushHandleAction = completion
    pageVC.scrollToVC(Page.main, direction: .forward)
  }
  
  func jkDidFinishScrolling(to pageIndex: Int) {
    if pageIndex == Page.main {
      pushHandleAction?()
      pushHandleAction = nil
    }
  }
  
//}
//extension MainCoordinator: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if navigationController.title == "historyNavVC" {
      navigationController.setNavigationBarHidden(true, animated: true)
      return
    }
    switch viewController {
    case is OnboardingVC:
      navigationController.isNavigationBarHidden = true
      case is MainVC:
      navigationController.isNavigationBarHidden = true
    case is ImproveVC:
      navigationController.isNavigationBarHidden = false
    default: break
    }
  }
//}
//extension MainCoordinator: OnboardingVCDelegate {
  func transitionToMainVC() {
    let window = UIApplication.shared.keyWindow!
    if window.rootViewController is MainVC {
      return
    }
    mainVC.view.alpha = 0
    window.backgroundColor = UIColor.white
    //
    pageVC.initialIndex = 1
    pageVC.pages = pages
    window.rootViewController = pageVC
    UIView.animate(withDuration: 1, animations: {
      self.mainVC.view.alpha = 1
    })
    
  }

//extension MainCoordinator: MainVCDelegate {
  
  func promptImprove() {
    improveVC.delegate = self
    //TODO:
    pageVC.present(improveVC, animated: true) { 
      //
    }
  }

  func presentIncomingVC() {
    if incomingVC == nil {
      incomingVC = IncomingCollectionVC()
    }
    incomingVC.delegate = self
    DispatchQueue.main.async {
      self.mainVC.addChildVC(self.incomingVC)
    }
  }
  
  func presentHistoriesVC() {
    //TODO: custom transition to historyVC
    historyVC.transitioningDelegate = self
    historyVC.delegate = self

    pageVC.present(historyNavVC!)
  }
  
  func mainVCWillDisappear() {
    if incomingVC != nil {
      incomingVC.stop()
      soloQueue.purge()
    }
  }
  
//extension MainCoordinator: ImproveVCDelegate, HistoryVCDelegate {
  
  func didFinishGettingImprove() {
    //TODO:
//    onboardingNavVC.popToRootViewControllerAnimated(true)
  }
  
  
//extension MainCoordinator: IncomingCollectionVCDelegate {

  func didRunOutOfSouls(_ ivc:IncomingCollectionVC) {
    self.mainVC.removeChildVC(ivc)
  }

//extension MainCoordinator: UIViewControllerTransitioningDelegate
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    zoomAnimator.originFrame = mainVC.appIconFrame()
    return zoomAnimator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    zoomAnimator.originFrame = mainVC.appIconFrame()
    return zoomAnimator
  }
  
  func historyDidSelect(soul: Soul) {
    if waveCoordinator == nil {
      waveCoordinator = WaveCoordinator(soul: soul)
      waveCoordinator!.delegate = self
    } else {
      waveCoordinator?.castSoul = soul
    }
    //TODO:
    historyNavVC!.pushViewController(waveCoordinator!.waveVC, animated: true)
    
    
  }
}

