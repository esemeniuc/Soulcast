//
//  Wave.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

enum WaveType: String {
  case call = "call"
  case reply = "reply"
}

struct Wave {
  let castVoice: Voice
  var callVoice: Voice
  var replyVoice: Voice?
  let casterToken: String
  let callerToken: String
  
  var type: WaveType
  let epoch: Int
  
  init(castVoice: Voice, callVoice: Voice, replyVoice: Voice?, casterToken: String, callerToken: String, type:WaveType, epoch: Int) {
    self.castVoice = castVoice
    self.callVoice = callVoice
    self.replyVoice = replyVoice
    self.casterToken = casterToken
    self.callerToken = callerToken
    self.type = type
    self.epoch = epoch
  }
  
  init(incomingSoul: Soul, call: Voice)   {
    castVoice = incomingSoul.voice
    callVoice = call
    replyVoice = nil
    type = .call
    casterToken = incomingSoul.token!
    callerToken = Device.token!
    epoch = Int(Date().timeIntervalSince1970)
  }
  
  mutating func append(reply:Voice){
    replyVoice = reply
    type = .reply
  }
  
  static func from(_ wrapperHash: [String : Any]) -> Wave {
    let hash = wrapperHash["wave"] as! [String: Any]
    let castVoice = Voice.from(hash["castVoice"] as! [String : Any])!
    let callVoice = Voice.from(hash["callVoice"] as! [String : Any])!
    let replyVoice = Voice.from(hash["replyVoice"] as! [String : Any]) //optional
    let casterToken = hash["casterToken"] as! String
    let callerToken = hash["callerToken"] as! String
    let type = (replyVoice == nil) ? WaveType.call : WaveType.reply
    let epoch = hash["epoch"] as! Int

    return Wave(
      castVoice: castVoice,
      callVoice: callVoice,
      replyVoice: replyVoice,
      casterToken: casterToken,
      callerToken: callerToken,
      type: type,
      epoch: epoch)
  }

  func toParams() ->  [String : Any] {
    var params =  [String : Any]()
    
    params["castVoice"] = castVoice.toParams()
    params["callVoice"] = callVoice.toParams()
    if replyVoice != nil {
      params["replyVoice"] = replyVoice!.toParams()
    }
    params["casterToken"] = casterToken
    params["callerToken"] = callerToken
    params["type"] = type.rawValue
    params["epoch"] = epoch
    
    return ["wave": params]
  }
  
  var debugDescription: String {
    return toParams().debugDescription
  }
}



