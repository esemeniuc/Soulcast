//
//  SoulCatcherTests.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-30.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

class SoulCatcherTests {
  let soulCatcher = SoulCatcher()
  let soulPlayer = SoulPlayer()
  
  
  func mockUserInfo() -> [NSString : AnyObject] {
    var mockUserInfo = [NSString : AnyObject]()
      var aps = [NSString : AnyObject]()
        aps["alert"] = "Hi2"
        aps["badge"] = 1
        aps["sound"] = "default"
    mockUserInfo["aps"] = aps
      var soulObject = [NSString : AnyObject]()
        soulObject["radius"] = 5
        soulObject["longitude"] = 10
        soulObject["latitude"] = 11
        soulObject["s3Key"] = "1428102802"
        soulObject["epoch"] = 1000000000
        soulObject["id"] = 14
        soulObject["device_id"] = 15
        soulObject["created_at"] = 5
        soulObject["token"] = 5
        soulObject["updated_at"] = 5
        soulObject["soulType"] = 5
    mockUserInfo[NSString(string: "soulObject")] = soulObject
    return mockUserInfo
  }

  
  func testIncoming() {
    soulCatcher.delegate = self
    soulCatcher.catchSoulObject(mockIncomingSoul())
    // troubleshooting:
    // try 
  }
  
  func testIncoming(userInfo: [NSObject : AnyObject]) {
    soulCatcher.delegate = self
    soulCatcher.catchSoul(userInfo)
  }
  
  func mockIncomingSoul() -> Soul {
    let seed = Soul()
    seed.s3Key = "1428102802"
    seed.epoch = 1428102802
    seed.longitude = -122.956074765067
    seed.latitude = 49.281255654105202
    seed.radius = 0.10652049519712301
    seed.type = .Broadcast
    let incomingDevice = Device()
    incomingDevice.id = 1
    //    seed.device = incomingDevice
    return seed
  }
  
}



extension SoulCatcherTests: SoulCatcherDelegate {
  func soulDidStartToDownload(soul:Soul) {
    print("soulDidStartToDownload")
  }
  func soulIsDownloading(progress:Float) {
    print("Downloading soul with progress: \(progress)")
  }
  func soulDidFinishDownloading(soul:Soul) {
    print("soulDidFinishDownloading")
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload() {
    print("soulDidFailToDownload")
    
  }
}