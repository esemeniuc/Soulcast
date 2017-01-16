//
//  SoulCatcherTests.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-30.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

class SoulCatcherTests {
  var soulCatcher: SoulCatcher?
  let soulPlayer = SoulPlayer()
  
  static func mockUserInfo() -> [NSString : AnyObject] {
    var mockUserInfo = [NSString : AnyObject]()
      var aps = [NSString : AnyObject]()
        aps["alert"] = "Hi2" as AnyObject?
        aps["badge"] = 1 as AnyObject?
        aps["sound"] = "default" as AnyObject?
    mockUserInfo["aps"] = aps as AnyObject?
      var soulObject = [NSString : AnyObject]()
        soulObject["radius"] = 5 as AnyObject?
        soulObject["longitude"] = 10 as AnyObject?
        soulObject["latitude"] = 11 as AnyObject?
        soulObject["s3Key"] = "1479619472" as AnyObject?
        soulObject["epoch"] = 1479619472 as AnyObject?
        soulObject["id"] = 14 as AnyObject?
        soulObject["device_id"] = 15 as AnyObject?
        soulObject["created_at"] = 5 as AnyObject?
        soulObject["token"] = 5 as AnyObject?
        soulObject["updated_at"] = 5 as AnyObject?
        soulObject["soulType"] = 5 as AnyObject?
    mockUserInfo[NSString(string: "soulObject")] = soulObject as AnyObject?
    return mockUserInfo
  }

  
  func testIncoming() {
    soulCatcher = SoulCatcher(soul: mockIncomingSoul())
    soulCatcher!.delegate = self
    // troubleshooting:
    // try 
  }
  
  func testIncoming(_ hash: [String : AnyObject]) {
    soulCatcher = SoulCatcher(soulHash: hash)
    soulCatcher!.delegate = self
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
  func soulDidStartToDownload(_ catcher: SoulCatcher, soul:Soul) {
    print("soulDidStartToDownload")
  }
  func soulIsDownloading(_ catcher: SoulCatcher, progress:Float) {
    print("Downloading soul with progress: \(progress)")
  }
  func soulDidFinishDownloading(_ catcher: SoulCatcher, soul:Soul) {
    print("soulDidFinishDownloading")
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload(_ catcher: SoulCatcher) {
    print("soulDidFailToDownload")
    
  }
}
