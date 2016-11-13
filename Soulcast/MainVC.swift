//
//  MainVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-22.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class MainVC: UIViewController {
  //
  let mapVC = MapVC()
  let outgoingVC = OutgoingVC()
  var incomingVC:IncomingCollectionVC!
  var soulCatchers = Set<SoulCatcher>()
  
  let improveVC = ImproveVC()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clearColor()
    let childVCs:[UIViewController] = [mapVC, outgoingVC]
    mapVC.delegate = self
    outgoingVC.delegate = self
    
    for eachVC in childVCs {
      addChildViewController(eachVC)
      view.addSubview(eachVC.view)
      eachVC.didMoveToParentViewController(self)
    }
    
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if !soloQueue.isEmpty {
      presentIncomingVC()
    }
    deviceManager.register(Device.localDevice)
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//        view.addSubview(IntegrationTestButton(frame:CGRect(x: 10, y: 10, width: 100, height: 100)))
    //    fetchLatestSoul()
    let improveButton = ImproveButton(frame: CGRectZero)
    
    improveButton.addTarget(self, action: #selector(improveButtonTapped), forControlEvents: .TouchUpInside)
    view.addSubview(improveButton)
    
    
  }
  
  func improveButtonTapped() {
    print("feedbackButtonTapped")
    promptImprove()
  }
  
  func promptImprove() {
    improveVC.delegate = self
    improveVC.modalPresentationStyle = .OverCurrentContext
    presentViewController(improveVC, animated: true) {
      //
    }
  }
  
  func fetchLatestSoul() {
    SoulCatcher.fetchLatest { resultSoul in
      if resultSoul != nil {
        self.displaySoul(resultSoul!)
      }
    }
  }
  
  func receiveRemoteNotification(soulObject:[String : AnyObject]){
    let tempSoulCatcher = SoulCatcher()
    tempSoulCatcher.delegate = self
    tempSoulCatcher.catchSoul(soulObject)
    soulCatchers.insert(tempSoulCatcher)
    
  }
  
  func displaySoul(incomingSoul:Soul) {
    if isViewLoaded() && view.window != nil {
      if soloQueue.isEmpty {
        presentIncomingVC()
      }
    }
    soloQueue.enqueue(incomingSoul)
  }
  
  func presentIncomingVC() {
    if incomingVC == nil {
      incomingVC = IncomingCollectionVC()
    }
    incomingVC.delegate = self
    addChildViewController(incomingVC)
    incomingVC.view.frame = IncomingCollectionVC.beforeFrame
    view.addSubview(incomingVC.view)
    incomingVC.view.userInteractionEnabled = true
    incomingVC.didMoveToParentViewController(self)
    UIView.animateWithDuration(0.67) {
      self.incomingVC.view.frame = IncomingCollectionVC.afterFrame
    }
  }
  
  static func getInstance(vc:UIViewController?) -> MainVC? {
    if vc is MainVC {
      return vc as? MainVC
    }
    if vc == nil {
      return nil
    }
    var hypothesis:MainVC? = nil
    for eachChildVC in (vc?.childViewControllers)! {
      if let found = getInstance(eachChildVC) {
        hypothesis = found
      }
    }
    return hypothesis
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

extension MainVC: OutgoingVCDelegate, MapVCDelegate {
  func mapVCDidChangeradius(radius:Double){
    
  }
  func outgoingRadius() -> Double{
    return mapVC.userSpan.latitudeDelta
  }
  func outgoingLongitude() -> Double{
    return (mapVC.latestLocation?.coordinate.longitude)!
  }
  func outgoingLatitude() -> Double{
    return (mapVC.latestLocation?.coordinate.latitude)!
  }
  func outgoingDidStart(){
    
  }
  func outgoingDidStop(){
    
  }
}

extension MainVC: SoulCatcherDelegate {
  func soulDidStartToDownload(catcher:SoulCatcher, soul:Soul){
    //TODO:
  }
  func soulIsDownloading(catcher:SoulCatcher, progress:Float){
    
  }
  func soulDidFinishDownloading(catcher:SoulCatcher, soul:Soul){
    //play audio if available...
    
    displaySoul(soul)
    soulCatchers.remove(catcher)
  }
  func soulDidFailToDownload(catcher:SoulCatcher){
    //TODO: notify..
    let alertController = UIAlertController(title: "Could not catch soul", message: "After trying numerous times to catch it, this one got away", preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
      //
    }
    alertController.addAction(okAction)
    presentViewController(alertController, animated: true) { 
      //
    }
    soulCatchers.remove(catcher)
  }
}

extension MainVC: IncomingCollectionVCDelegate {
  func didRunOutOfSouls() {
    dismissIncomingVC()
  }
}

extension MainVC: ImproveVCDelegate {
  func didFinishGettingImprove() {
    improveVC.dismissViewControllerAnimated(true) {
      //
    }
  }
}

