
import Foundation
import UIKit

class SoulRecorderTests {
  
  let recorder = SoulRecorder()
  let player = SoulPlayer()
  
  
  
  func testRecording(){
    recorder.delegate = self
    recorder.pleaseStartRecording()
    let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.recorder.pleaseStopRecording()
    }
  }
  
}



extension SoulRecorderTests: SoulRecorderDelegate {
  internal func recorderDidFinishRecording(_ localURL: String) {
    print("SoulTester soulDidFinishRecording")
    let newSoul = Soul(voice: Voice(
      epoch: 0,
      s3Key: "",
      localURL: localURL))
    player.startPlaying(newSoul)
  }
  
  func soulDidStartRecording(){
    print("SoulTester soulDidStartRecording")
  }
  func soulIsRecording(_ progress: CGFloat) {
    //
  }
  func soulDidFailToRecord(){
    print("SoulTester soulDidFailToRecord")
  }
  func soulDidReachMinimumDuration(){
    
  }
}
