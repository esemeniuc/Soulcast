

import UIKit
import AVFoundation

let soulPlayer = SoulPlayer()

protocol SoulPlayerDelegate: AnyObject {
  func didStartPlaying(_ soul:Soul)
  func didFinishPlaying(_ soul:Soul)
  func didFailToPlay(_ soul:Soul)
}

class SoulPlayer: NSObject, AVAudioPlayerDelegate {
  fileprivate var tempSoul: Soul?
  var audioPlayer: AVAudioPlayer?
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
      audioPlayer = try AVAudioPlayer(contentsOf: filePath)
      let player = audioPlayer!
      player.prepareToPlay()
      player.play()
      player.delegate = self
      SoulPlayer.playing = true
      sendStartMessage(soul)
    } catch let error as NSError {
      print(error.description)
      self.sendFailMessage(soul)
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
    audioPlayer = nil
    SoulPlayer.playing = false
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
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    reset()
    if let soul = tempSoul {
      sendFinishMessage(soul)
    }
  }
  
}
