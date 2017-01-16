
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
  func soulDidStartRecording(){
    print("SoulTester soulDidStartRecording")
  }
    func soulIsRecording(_ progress: CGFloat) {
        //
    }
  func soulDidFinishRecording(_ newSoul: Soul){
    print("SoulTester soulDidFinishRecording")
    player.startPlaying(newSoul)
  }
  func soulDidFailToRecord(){
    print("SoulTester soulDidFailToRecord")
  }
  func soulDidReachMinimumDuration(){
    
  }
}
