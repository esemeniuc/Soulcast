//
//  InWaveVC.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class InWaveVC: UIViewController {
  let inWave: Wave
  init(wave: Wave) {
    self.inWave = wave
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: layout inwave
  }
}
