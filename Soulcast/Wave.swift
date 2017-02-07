//
//  Wave.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

enum WaveType {
  case birth
  case call
  case reply
}

struct Wave {
  let castVoice: Voice
  var callVoice: Voice?
  var replyVoice: Voice?
  let casterToken: String
  let callerToken: String
  
  let type: WaveType
  let epoch: Int
  
  func append(call:Voice) -> Wave {
    
  }
  
  func append(reply:Voice) -> Wave {
    
  }

}

