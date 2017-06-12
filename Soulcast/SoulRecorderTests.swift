
import Foundation
import UIKit

class SoulRecorderTests {
  
  func testRecording(){
    let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      
    }
  }
  
}



extension SoulRecorderTests: RecorderSubscriber {
  func recorderStarted() {}
  func recorderReachedMinDuration() {}
  func recorderRecording(_ progress:CGFloat) {}
  func recorderFinished(_ localURL: URL) {}
  func recorderFailed() {}
  var hashValue: Int { return 0 }
}
