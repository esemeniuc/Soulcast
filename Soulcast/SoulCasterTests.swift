//
//  SoulCasterTests.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-30.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

class SoulCasterTests {
  
  let soulCaster = SoulCaster()
  
  func testOutgoing(){
    soulCaster.delegate = self
    soulCaster.cast(SoulCasterTests.mockSoul())
  }
  
  func testOutgoingJson() {
    soulCaster.delegate = self
    soulCaster.postToServer(SoulCasterTests.mockSoul())
  }
  
  class func mockSoul() -> Soul {
    let seed = Soul()
    //TODO: switch out localURL for a valid file
    seed.localURL = "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/549676D1-DB20-401E-8ED9-E67142EC5BE2/Documents/Recording494031955.70334.m4a"
    seed.s3Key = "1428104002"
    seed.epoch = 14932432
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    seed.radius = 0.333
    seed.token = "95d025d6bc4a7a773da2d19148cde93912e9ba4d8f92bb77483ab46693cdc5c6"
    return seed
  }
  
}

extension SoulCasterTests: SoulCasterDelegate {
  func soulDidStartUploading() {
    
  }
  func soulIsUploading(progress:Float) {
    
  }
  func soulDidFinishUploading(soul:Soul) {
    print("soulDidFinishUploading from delegate!")
  }
  func soulDidFailToUpload() {
    
  }
  func soulDidReachServer() {
    
  }
}