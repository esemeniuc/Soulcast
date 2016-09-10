

import UIKit
import TheAmazingAudioEngine

let soulPlayer = SoulPlayer()

protocol SoulPlayerDelegate: AnyObject {
  func didStartPlaying(soul:Soul)
  func didFinishPlaying(soul:Soul)
  func didFailToPlay(soul:Soul)
}

class SoulPlayer: NSObject {
  private var tempSoul: Soul!
  private var player: AEAudioFilePlayer!
  static var playing = false
  private var subscribers:[SoulPlayerDelegate] = []
  
  func startPlaying(soul:Soul!) {
    guard !SoulPlayer.playing else{
      return
    }
    tempSoul = soul
    let filePath = NSURL(fileURLWithPath: soul.localURL! as String)
    do {
      player = try AEAudioFilePlayer(URL: filePath)
      audioController.addChannels([player])
      player?.removeUponFinish = true
      SoulPlayer.playing = true
      sendStartMessage(soul)
      player?.completionBlock = {
        self.reset()
        SoulPlayer.playing = false
        self.sendFinishMessage(soul)
      }
    } catch {
      assert(false);
      sendFailMessage(soul)
      print("oh noes! playAudioAtPath fail")
      return
    }

  }
  
  func sendStartMessage(soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didStartPlaying(soul)
    }
  }
  
  func sendFinishMessage(soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFinishPlaying(soul)
    }
  }
  
  func sendFailMessage(soul:Soul) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFailToPlay(soul)
    }
  }
  
  func reset() {
    audioController.removeChannels([player])
    
  }
  
  func subscribe(subscriber:SoulPlayerDelegate) {
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
  
  func unsubscribe(subscriber:SoulPlayerDelegate) {
    if let removalIndex = subscribers.indexOf({$0 === subscriber}) {
      subscribers.removeAtIndex(removalIndex)
    }

  }
  
}
