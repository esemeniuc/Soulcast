/*
 Usage:
 Use NSNotificationCenter defaultCenter to listen to soulDidFinishPlaying and soulDidFailToPlay
 
*/

import UIKit
import TheAmazingAudioEngine


class SoulPlayer: NSObject {
  private var tempSoul: Soul!
  private var player: AEAudioFilePlayer!
  
  func startPlaying(soul:Soul!) {
    tempSoul = soul
    let filePath = NSURL(fileURLWithPath: soul.localURL! as String)
    do {
      player = try AEAudioFilePlayer(URL: filePath)
      audioController.addChannels([player])
      player?.removeUponFinish = true
      player?.completionBlock = {
        NSNotificationCenter.defaultCenter().postNotificationName("soulDidFinishPlaying", object: self.tempSoul)
        self.reset()
      }
    } catch {
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
