//
//  VoiceTests.swift
//  Soulcast
//
//  Created by June Kim on 2017-03-26.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

class VoiceTests {
  init() {
    //waveCallTest()
    //waveReplyTest()
    interfaceTest()
  }
  
  func interfaceTest() {
    let wave = MockFactory.waveOne()
    print(wave.toParams())
    
    let translatedWave = Wave.from(wave.toParams())
    print(translatedWave.toParams())
    
    ServerFacade.post(wave, { 
      //
    }) { (status) in
      print(status)
    }
    
  }
  
  func waveCallTest() {
    //make a mock soul
    let incomingSoul = MockFactory.mockSoulOne()
    //get a caster key
    let casterToken = incomingSoul.token!
    //make a caller key
    let callerToken = Device.token!
    //make a voice 
    let callVoice = MockFactory.voiceOne()
    //make a wave from soul and voice
    let newWave = Wave(castVoice: incomingSoul.voice, callVoice: callVoice, replyVoice: nil, casterToken: casterToken, callerToken: callerToken, type: .call, epoch: 12321321)
    //post the wave through server facade
    MockServerFacade.post(newWave) {
      
    }
    
  }
  
  func waveReplyTest() {
    var calledWave = Wave(
      castVoice: MockFactory.voiceOne(),
      callVoice: MockFactory.voiceOne(),
      replyVoice: nil,
      casterToken: Device.token!,
      callerToken: "callertoken",
      type: .call,
      epoch: 12344321234)
    calledWave.append(reply: MockFactory.voiceOne())
    
  }
  
}
