
import Foundation
import UIKit

class SoulRecorderTests {
  
  let recorder = SoulRecorder()
  let player = SoulPlayer()
  
  
  
  func testRecording(){
    recorder.delegate = self
    recorder.pleaseStartRecording()
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.recorder.pleaseStopRecording()
    }
  }
  
}



extension SoulRecorderTests: SoulRecorderDelegate {
  func soulDidStartRecording(){
    print("SoulTester soulDidStartRecording")
  }
    func soulIsRecording(progress: CGFloat) {
        //
    }
  func soulDidFinishRecording(newSoul: Soul){
    print("SoulTester soulDidFinishRecording")
    player.startPlaying(newSoul)
  }
  func soulDidFailToRecord(){
    print("SoulTester soulDidFailToRecord")
  }
  func soulDidReachMinimumDuration(){
    
  }
}
