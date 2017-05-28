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
  var castVoice: Voice
  var callVoice: Voice
  var replyVoice: Voice?
  let casterID: Int
  let callerID: Int
  let casterOS: OS
  let callerOS: OS
  
  var type: WaveType
  let epoch: Int
  
  init(castVoice: Voice, callVoice: Voice, replyVoice: Voice?, casterID: Int, callerID: Int, type:WaveType, casterOS: OS, callerOS: OS, epoch: Int) {
    self.castVoice = castVoice
    self.callVoice = callVoice
    self.replyVoice = replyVoice
    self.casterID = casterID
    self.callerID = callerID
    self.type = type
    self.epoch = epoch
    self.casterOS = casterOS
    self.callerOS = callerOS
    
  }
  
  init(incomingSoul: Soul, call: Voice)   {
    castVoice = incomingSoul.voice
    callVoice = call
    replyVoice = nil
    type = .call
    casterID = incomingSoul.deviceID ?? -1
    callerID = Device.id!
    callerOS = Device.isSimulator ? OS.simulator : OS.ios
    casterOS = incomingSoul.os 
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
    let casterID = hash["casterID"] as! Int
    let callerID = hash["callerID"] as! Int
    let type = (replyVoice == nil) ? WaveType.call : WaveType.reply
    let epoch = hash["epoch"] as! Int
    let casterOS = OS(rawValue:hash["casterOS"] as! String) ?? OS.ios
    let callerOS = OS(rawValue:hash["callerOS"] as! String) ?? OS.ios
    return Wave(
      castVoice: castVoice,
      callVoice: callVoice,
      replyVoice: replyVoice,
      casterID: casterID,
      callerID: callerID,
      type: type,
      casterOS: casterOS,
      callerOS: callerOS,
      epoch: epoch)
  }

  func toParams() ->  [String : Any] {
    var params =  [String : Any]()
    
    params["castVoice"] = castVoice.toParams()
    params["callVoice"] = callVoice.toParams()
    if replyVoice != nil {
      params["replyVoice"] = replyVoice!.toParams()
    }
    params["casterID"] = casterID
    params["callerID"] = callerID
    params["casterOS"] = casterOS.rawValue
    params["callerOS"] = callerOS.rawValue
    params["type"] = type.rawValue
    params["epoch"] = epoch
    
    return ["wave": params]
  }
  
  var debugDescription: String {
    return toParams().debugDescription
  }
}



