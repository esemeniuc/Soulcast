
import Foundation

class SoulPlayerTests {
  let soulPlayer = SoulPlayer()
  
  
  func testPlay(){
    soulPlayer.startPlaying(mockSoul())
  }
  
  func mockSoul() -> Soul {
    let seed = Soul()
    //TODO: switch out localURL for a valid file
    seed.localURL = "TODOTODO lalala"
    seed.epoch = 14932432
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    return seed
  }
  
  
}