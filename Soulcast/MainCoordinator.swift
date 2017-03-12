//
//  MainCoordinator.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, JKPageVCDelegate, UINavigationControllerDelegate, OnboardingVCDelegate, MainVCDelegate, ImproveVCDelegate, HistoryVCDelegate, IncomingCollectionVCDelegate {
  let pageVC = JKPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  var mainVC: MainVC = MainVC()
  fileprivate var navVC: UINavigationController?
  let historyVC = HistoryVC()
  var incomingVC:IncomingCollectionVC!
  let improveVC = ImproveVC()
  var onboardingVC: OnboardingVC?
  var pages: [UIViewController] = []
  var pushHandleAction:(()->())? = nil
  
  var rootVC:UIViewController {
//    return HistoryVC()
    if navVC != nil {
      return navVC!
    } else {
      return pageVC
    }
  }
  
  struct Page {
    static let history = 0
    static let main = 1
  }
  
  override init() {
    pages = [historyVC, mainVC]
    if Receptionist.needsOnboarding() {
      onboardingVC = OnboardingVC()
      navVC = UINavigationController(rootViewController: onboardingVC!)
      super.init()
      onboardingVC!.delegate = self
      navVC!.delegate = self
    } else {
      pageVC.initialIndex = 1
      pageVC.pages = pages
      
      super.init()
    }
    pageVC.jkDelegate = self
    pageVC.disableScroll()
    mainVC.delegate = self
    addPageTab()
  }
  
  func addPageTab() {
    let leftTab = PageTab(direction: .left)
    let leftTabTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabTapped))
    leftTab.addGestureRecognizer(leftTabTapRecognizer)
    mainVC.view.addSubview(leftTab)

    let rightTab = PageTab(direction: .right)
    let rightTabTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabTapped))
    rightTab.addGestureRecognizer(rightTabTapRecognizer)
    historyVC.view.addSubview(rightTab)
  }
  
  func tabTapped() {
    if pageVC.currentIndex == Page.history {
      pageVC.scrollToVC(Page.main, direction: .forward)
    } else if pageVC.currentIndex == Page.main {
      pageVC.scrollToVC(Page.history, direction: .reverse)
    }
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

//}
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
  
  func mainVCWillDisappear() {
    if incomingVC != nil {
      incomingVC.stop()
      soloQueue.purge()
    }
  }
  
//}
//extension MainCoordinator: ImproveVCDelegate, HistoryVCDelegate {
  
  func didFinishGettingImprove() {
    //TODO:
//    navVC.popToRootViewControllerAnimated(true)
  }
  
  
//}
//extension MainCoordinator: IncomingCollectionVCDelegate {

  func didRunOutOfSouls(_ ivc:IncomingCollectionVC) {
    self.mainVC.removeChildVC(ivc)
  }
  
}

