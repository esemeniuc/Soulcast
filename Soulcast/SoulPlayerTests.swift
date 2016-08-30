
import Foundation

class SoulPlayerTests {
  let soulPlayer = SoulPlayer()
  
  
  func testPlay(){
    soulPlayer.startPlaying(mockSoul())
  }
  
  func mockSoul() -> Soul {
    let seed = Soul()
    //TODO: switch out localURL for a valid file
    seed.localURL = "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/549676D1-DB20-401E-8ED9-E67142EC5BE2/Documents/Recording494031955.70334.m4a"
    seed.s3Key = "1428104002"
    seed.epoch = 14932432
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    return seed
  }
  
  
}