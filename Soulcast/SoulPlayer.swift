/*
 Usage:
 Use NSNotificationCenter defaultCenter to listen to soulDidFinishPlaying and soulDidFailToPlay
 
*/

import UIKit
import TheAmazingAudioEngine


class SoulPlayer: NSObject {
  private var tempSoul: Soul!
  private var player: AEAudioFilePlayer!
  static var playing = false
  
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
      player?.completionBlock = {
        self.reset()
        SoulPlayer.playing = false
      }
    } catch is ErrorType {
      assert(false);
      print("oh noes! playAudioAtPath fail")
      NSNotificationCenter.defaultCenter().postNotificationName("soulDidFailToPlay", object: self.tempSoul)
      return
    }

  }
  
  func reset() {
    audioController.removeChannels([player])
    
  }
  
}
