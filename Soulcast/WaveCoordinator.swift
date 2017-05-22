//
//  WaveCoordinator.swift
//  Soulcast
//
//  Created by June Kim on 2017-05-21.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol WaveCoordinatorDelegate: class {
  //TODO:
}

class WaveCoordinator: OutWaveVCDelegate {
  weak var delegate:  WaveCoordinatorDelegate?
  var castSoul: Soul
  var waveVC: OutWaveVC {
    let vc = OutWaveVC()
    vc.delegate = self
    vc.castSoul = castSoul
    return vc
  }
  
  init(soul: Soul) {
    self.castSoul = soul
  }
  
  func outWaveDidCall(wave: Wave) {
    ServerFacade.post(wave, {
      //
    }) { (statuscode) in
      
    }
  }
  
  
}
