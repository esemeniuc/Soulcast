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
  
  
  
}

extension MainVC: OutgoingVCDelegate, MapVCDelegate {
  func mapVCDidChangeradius(radius:Double){
    //TODO: enable update to server periodically
  }
  func outgoingRadius() -> Double{
    return Device.localDevice.radius!
  }
  func outgoingLongitude() -> Double{
    return Device.localDevice.longitude!
  }
  func outgoingLatitude() -> Double{
    return Device.localDevice.latitude!
  }
  func outgoingDidStart(){
    
  }
  func outgoingDidStop(){
    
  }
}