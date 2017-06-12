
import Foundation

class SoulPlayerTests {
  
  
  func testPlay(){
  }
  
  func mockSoul() -> Soul {
    let seed = Soul(voice: Voice(
      epoch: 14932432,
      s3Key: nil,
      localURL: "TODOTODO lalala"))
    //TODO: switch out localURL for a valid file
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    return seed
  }
  
  
}
