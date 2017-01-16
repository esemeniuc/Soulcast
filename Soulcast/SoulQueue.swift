
import Foundation


let singleSoulQueue = SoulQueue()

//a data type to temporarily store souls
class SoulQueue {
  
  var elementCount:Int = 0
  
  func enqueue(_ incomingSoul:Soul){
//    assert(incomingSoul.type == .Broadcast)
    
    elementCount += 1
  }
  
}
