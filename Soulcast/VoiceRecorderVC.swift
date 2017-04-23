//
//  VoiceRecorderVC.swift
//  Soulcast
//
//  Created by June Kim on 2017-04-23.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol VoiceRecorderVCDelegate: class {
  func voiceRecorderWillStartRecording(_:VoiceRecorderVC)
  func voiceRecorderFailedRecording(_:VoiceRecorderVC)
  func voiceRecorderFinishedRecording(_:VoiceRecorderVC, voice:Voice)
}

///combines recording ui and recording logic. To be used as a child VC
class VoiceRecorderVC: UIViewController {

  let recordButton = RecordButton()
  let minimumDuration = 1
  var maximumDuration = 3
  var soulRecorder = SoulRecorder()
  
  
}
