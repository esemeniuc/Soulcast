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
  var incomingVC:IncomingVC?
  
  
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
    //respond to incoming messages by launching an incomingVC
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceiveSoul), name: SoulCatcher.soulCaughtNotification, object: nil)
    
    
  }
  
  func didReceiveSoul(catcher:SoulCatcher) {
    //respond to incoming messages by launching an incomingVC
    incomingVC = IncomingVC()
    addChildViewController(incomingVC!)
    view.addSubview(incomingVC!.view)
    incomingVC?.incomingCatcher = catcher
    incomingVC?.didMoveToParentViewController(self)
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