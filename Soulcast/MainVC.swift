//
//  MainVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-22.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol MainVCDelegate: class {
  func promptImprove()
  func presentIncomingVC()
}

class MainVC: UIViewController {
  let mapVC = MapVC()
  let outgoingVC = OutgoingVC()
  var soulCatchers = Set<SoulCatcher>()
  
  weak var delegate: MainVCDelegate?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clearColor()
    add(children:[mapVC, outgoingVC])
    addImproveButton()
  }
  
  func addImproveButton() {
    let improveButton = ImproveButton(frame: CGRectZero)
    improveButton.addTarget(self, action: #selector(improveButtonTapped), forControlEvents: .TouchUpInside)
    view.addSubview(improveButton)
  }
  
  func add(children childVCs:[UIViewController]) {
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
    pushHandler.activate()
//        view.addSubview(IntegrationTestButton(frame:CGRect(x: 10, y: 10, width: 100, height: 100)))
    
  }
  
  func improveButtonTapped() {
    print("feedbackButtonTapped")
    delegate?.promptImprove()
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
        delegate?.presentIncomingVC()
      }
    }
    soloQueue.enqueue(incomingSoul)
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


