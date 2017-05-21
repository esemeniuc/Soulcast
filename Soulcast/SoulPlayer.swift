
import UIKit
import TheAmazingAudioEngine

let soulPlayer = SoulPlayer()

protocol SoulPlayerDelegate: AnyObject {
  func didStartPlaying(_ voice:Voice)
  func didFinishPlaying(_ voice:Voice)
  func didFailToPlay(_ voice:Voice)
}

class SoulPlayer: NSObject {
  fileprivate var tempSoul: Soul?
  fileprivate var player: AEAudioFilePlayer?
  static var playing = false
  fileprivate var subscribers:[SoulPlayerDelegate] = []
  
  func startPlaying(_ voice:Voice) {
    guard !SoulPlayer.playing else{
      reset()
      startPlaying(voice)
      return
    }
    let filePath = URL(fileURLWithPath: voice.localURL! as String)
    do {
      player = try AEAudioFilePlayer(url: filePath)
      audioController?.addChannels([player!])
      player?.removeUponFinish = true
      SoulPlayer.playing = true
      sendStartMessage(voice)
      player?.completionBlock = {
        self.reset()
        self.sendFinishMessage(voice)
      }
    } catch {
      assert(false);
      sendFailMessage(voice)
      print("oh noes! playAudioAtPath fail")
      return
    }
    
  }
  
  func startPlaying(_ soul:Soul!) {
    guard !SoulPlayer.playing else{
      reset()
      startPlaying(soul)
      return
    }
    tempSoul = soul
    let filePath = URL(fileURLWithPath: soul.voice.localURL! as String)
    do {
      player = try AEAudioFilePlayer(url: filePath)
      audioController?.addChannels([player!])
      player?.removeUponFinish = true
      SoulPlayer.playing = true
      sendStartMessage(soul.voice)
      player?.completionBlock = {
        self.reset()
        self.sendFinishMessage(soul.voice)
      }
    } catch {
      assert(false);
      sendFailMessage(soul.voice)
      print("oh noes! playAudioAtPath fail")
      return
    }

  }
  
  func lastSoul() -> Soul? {
    return tempSoul
  }
  
  func sendStartMessage(_ voice:Voice) {
    for eachSubscriber in subscribers {
      eachSubscriber.didStartPlaying(voice)
    }
  }
  
  func sendFinishMessage(_ voice:Voice) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFinishPlaying(voice)
    }
  }
  
  func sendFailMessage(_ voice:Voice) {
    for eachSubscriber in subscribers {
      eachSubscriber.didFailToPlay(voice)
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
