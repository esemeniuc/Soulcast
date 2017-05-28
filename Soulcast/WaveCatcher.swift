//
//  WaveCatcher.swift
//  Soulcast
//
//  Created by June Kim on 2017-03-26.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

class WaveCatcher: NSObject, VoiceFetcherDelegate {
  static let catcher = WaveCatcher()
  var catchCompletion:((Wave)->())?
  var fetchers:[VoiceFetcher] = []
  var voices:[Voice] = []
  var tempWave: Wave?

  override init() {
    super.init()
  }
  
  func catchWave(_ wave:Wave, completion: @escaping (Wave)->()) {
    //fill in the blanks
    var castVoice = wave.castVoice
    castVoice.context = .waveCast
    castVoice.contextEpoch = wave.epoch
    let castFetcher = VoiceFetcher(voice: castVoice)
    castFetcher.waveEpoch = wave.epoch
    castFetcher.delegate = self
    fetchers.append(castFetcher)
    
    var callVoice = wave.callVoice
    callVoice.context = .waveCall
    callVoice.contextEpoch = wave.epoch
    let callFetcher = VoiceFetcher(voice:callVoice)
    callFetcher.waveEpoch = wave.epoch
    callFetcher.delegate = self
    fetchers.append(callFetcher)
    
    if var replyVoice = wave.replyVoice {
      replyVoice.context = .waveReply
      replyVoice.contextEpoch = wave.epoch
      let replyFetcher = VoiceFetcher(voice:replyVoice)
      replyFetcher.waveEpoch = wave.epoch
      replyFetcher.delegate = self
      fetchers.append(replyFetcher)
    }
    catchCompletion = completion
    tempWave = wave
  }

  func voiceDidFinishDownloading(_ fetcher: VoiceFetcher, voice: Voice) {
    //find by wave epoch
    voices.append(voice)
    if let index = fetchers.index(of: fetcher) {
      fetchers.remove(at: index)
    }
    if let wave = tempWave,
      let finishedWave = hasFinishedFetching(wave: wave, voices: voices),
      let completion = catchCompletion {
      completion(finishedWave)
      catchCompletion = nil
    }
    
  }
  
  func voiceDidFailToDownload(_ fetcher: VoiceFetcher) {
    //
    if let index = fetchers.index(of: fetcher) {
      fetchers.remove(at: index)
    }
  }
  
  func hasFinishedFetching(wave:Wave, voices: [Voice]) -> Wave? {
    if voices.count == 0 { return nil }
    let containsCast = voices.contains(where: { $0.context == .waveCast && $0.contextEpoch == wave.epoch })
    let containsCall = voices.contains(where: { $0.context == .waveCall && $0.contextEpoch == wave.epoch })
    let containsReply = voices.contains(where: { $0.context == .waveReply && $0.contextEpoch == wave.epoch })
    var finishingWave = wave
    if wave.type == .call && containsCast && containsCall {
      for eachVoice in voices {
        if eachVoice.context == .waveCast && eachVoice.contextEpoch == wave.epoch {
          finishingWave.castVoice = eachVoice
        }
        if eachVoice.context == .waveCast && eachVoice.contextEpoch == wave.epoch {
          finishingWave.callVoice = eachVoice
        }
      }
      return finishingWave
    } else if wave.type == .reply && containsCast && containsCall && containsReply {
      for eachVoice in voices {
        if eachVoice.context == .waveCast && eachVoice.contextEpoch == wave.epoch {
          finishingWave.castVoice = eachVoice
        }
        if eachVoice.context == .waveCast && eachVoice.contextEpoch == wave.epoch {
          finishingWave.callVoice = eachVoice
        }
        if eachVoice.context == .waveReply && eachVoice.contextEpoch == wave.epoch {
          finishingWave.replyVoice = eachVoice
        }
      }
      return finishingWave
    }
    return nil
  }
  
}
