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
  
  
  static func mockUserInfo() -> [NSString : AnyObject] {
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
        soulObject["s3Key"] = "1473035478"
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
  
  func testIncoming(userInfo: [String : AnyObject]) {
    soulCatcher.delegate = self
    soulCatcher.catchSoul(userInfo["aps"] as! [String: AnyObject])
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
  func soulDidStartToDownload(catcher: SoulCatcher, soul:Soul) {
    print("soulDidStartToDownload")
  }
  func soulIsDownloading(catcher: SoulCatcher, progress:Float) {
    print("Downloading soul with progress: \(progress)")
  }
  func soulDidFinishDownloading(catcher: SoulCatcher, soul:Soul) {
    print("soulDidFinishDownloading")
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload(catcher: SoulCatcher) {
    print("soulDidFailToDownload")
    
  }
}