//
//  LaunchHelper.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit
import AWSS3


class LaunchHelper {
  static func update(_ id: Int){
    
  }
  
  static func launch() {
    ServerFacade.register()
    UIApplication.shared.applicationIconBadgeNumber = 0
    configureAWS()
  }
  
  static func configureAWS() {
    let credentialsProvider = AWSCognitoCredentialsProvider(
      regionType: .USWest2,
      identityPoolId: CognitoIdentityPoolId)
    let configuration = AWSServiceConfiguration(
      region: .USWest2,
      credentialsProvider: credentialsProvider)
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    AWSLogger.default().logLevel = .verbose
  }
  
}
