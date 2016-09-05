//
//  AudioPermissionVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-05.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

class AudioPermissionVC: PermissionVC {
  let audioTitle = "Microphone Access"
  let audioDescription = "To be able to cast your voice to those around you, we need microphone access"

  init() {
    super.init(title: audioTitle, description: audioDescription) { }
    requestAction = {
      SoulRecorder.askForMicrophonePermission({
        self.gotPermission()
        }, failure: {
          self.deniedPermission()
      })
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}