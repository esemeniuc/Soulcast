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
  var incomingVC = IncomingCollectionVC()
  var soulCatchers = Set<SoulCatcher>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.blueColor()
    let childVCs:[UIViewController] = [mapVC, outgoingVC]
    mapVC.delegate = self
    outgoingVC.delegate = self
    
    for eachVC in childVCs {
      addChildViewController(eachVC)
      view.addSubview(eachVC.view)
      eachVC.didMoveToParentViewController(self)
    }
    
    
  }
  
  func receiveRemoteNotification(userInfo:[NSObject : AnyObject]){
    let tempSoulCatcher = SoulCatcher()
    tempSoulCatcher.delegate = self
    tempSoulCatcher.catchSoul(userInfo)
    soulCatchers.insert(tempSoulCatcher)
    //TODO
    
  }
  
  func displaySoul(incomingSoul:Soul) {
    //respond to incoming messages by launching an incomingVC
    if soloQueue.count == 0 {
      addChildViewController(incomingVC)
      view.addSubview(incomingVC.view)
      incomingVC.didMoveToParentViewController(self)
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
    print("mapVCDidChangeradius: \(radius)")
    //TODO: enable update to server periodically
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
    soulCatchers.remove(catcher)
  }
}