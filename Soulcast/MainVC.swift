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
  
  var childVCs:[UIViewController] = [RecordingVC(), MapVC()]
  //  let outgoingVC = OutgoingVC()
//  let incomingVC = IncomingVC()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.blueColor()
  }
  
  
  
}