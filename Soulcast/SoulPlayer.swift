

import UIKit
import TheAmazingAudioEngine

let soulPlayer = SoulPlayer()

protocol SoulPlayerDelegate: AnyObject {
  func didStartPlaying(_ soul:Soul)
  func didFinishPlaying(_ soul:Soul)
  func didFailToPlay(_ soul:Soul)
}

class SoulPlayer: NSObject {
  fileprivate var tempSoul: Soul?
  fileprivate var player: AEAudioFilePlayer?
  static var playing = false
  fileprivate var subscribers:[SoulPlayerDelegate] = []
  
  func startPlaying(_ soul:Soul!) {
    guard !SoulPlayer.playing else{
      reset()
      startPlaying(soul)
      return
    }
    tempSoul = soul
    let filePath = URL(fileURLWithPath: soul.localURL! as String)
    do {
      player = try AEAudioFilePlayer(url: filePath)
      audioController?.addChannels([player!])
      player?.removeUponFinish = true
      SoulPlayer.playing = true
      sendStartMessage(soul)
      player?.completionBlock = {
        self.reset()
        
        self.sendFinishMessage(soul)
      }
    } catch {
      assert(false);
      sendFailMessage(soul)
      print("oh noes! playAudioAtPath fail")
      return
    }

  }
  
  func lastSoul() -> Soul? {
    return tempSoul
  }
  
  func sendStartMessage(_ soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didStartPlaying(soul)
    }
  }
  
  func sendFinishMessage(_ soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFinishPlaying(soul)
    }
  }
  
  func sendFailMessage(_ soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFailToPlay(soul)
    }
  }
  
  func reset() {
    if player != nil {
      audioController?.removeChannels([player!])
      SoulPlayer.playing = false
    }
  }
  
  func subscribe(_ subscriber:SoulPlayerDelegate) {
    var contains = false
    for eachSubscriber in subscribers {
      if eachSubscriber === subscriber {
        contains = true
        break
      }
    }
    if !contains {
      subscribers.append(subscriber)

    } 
  }
  
  func unsubscribe(_ subscriber:SoulPlayerDelegate) {
    if let removalIndex = subscribers.index(where: {$0 === subscriber}) {
      subscribers.remove(at: removalIndex)
    }

  }
  
}
