//
//  MainCoordinator.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {
  let mainVC = MainVC()
  
  var launchingViewController: UIViewController {
    if Receptionist.needsOnboarding() {
      return OnboardingVC()
    } else {
      return MainVC()
    }
  }
  
}
