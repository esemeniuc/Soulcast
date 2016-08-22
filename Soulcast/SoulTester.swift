//
//  SoulTests.swift
//  SoulCast
//
//  Created by Camvy Films on 2015-04-04.
//  Copyright (c) 2015 June. All rights reserved.
//
import Foundation

let soulTester = SoulTester()

class SoulTester: NSObject {
  
  let soulPlayer = SoulPlayer()

  
  func setup() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.uploadingFinished), name: "uploadingFinished", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.soulDidFailToPlay(_:)), name: "soulDidFailToPlay", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.soulDidFinishPlaying(_:)), name: "soulDidFinishPlaying", object: nil)
    
    
  }
  
  func soulSeed() -> Soul {
    let seed = Soul()
    seed.s3Key = "1428104002"
    seed.epoch = 14932432
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    seed.token = seedDevice().token
    return seed
  }
  
  func soulIncomingSeed() -> Soul {
    let seed = Soul()
    seed.s3Key = "1428283167"
    seed.epoch = 1428283167
    seed.longitude = -122.956074765067
    seed.latitude = 49.281255654105202
    seed.radius = 0.10652049519712301
    let incomingDevice = Device()
    incomingDevice.id = 1
//    seed.device = incomingDevice
    return seed
  }
  
  func seedDevice() -> Device {
    let seed = Device()
    seed.token = "e35c22814ff6b5217ac3823403a59bdc958fc9e20ef865b322546b1afefd552a"
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    seed.arn = "arn:aws:sns:us-east-1:503476828113:endpoint/APNS_SANDBOX/Soulcast_Development/a08b89b5-3015-3d4b-a14a-f0e657fffedb"
    return seed
  }
  
  func testOutgoing(soul:Soul) {
    //soulcaster
    let singleSoulCaster = SoulCaster()
    singleSoulCaster.upload(soul)
    singleSoulCaster.castSoulToServer(soul)
  }
  
  func uploadingFinished() {
    print("soulTester uploadingFinished")
  }
  
  func testIncoming(userInfo:NSDictionary) {
    print("testIncoming userInfo: \(userInfo)")
    soulCatcher.catchSoul(userInfo)
    
  }
  
  func soulDidFailToPlay(notification:NSNotification) {
    let failSoul = notification.object as! Soul
    
  }
  
  func soulDidFinishPlaying(notification:NSNotification) {
    let finishedSoul = notification.object as! Soul
    
  }
  
//  func getObjectRequest() -> AWSS3GetObjectRequest {
//    let request = AWSS3GetObjectRequest()
//    request.bucket = S3BucketName
//    request.key = soulIncomingSeed().s3Key! + ".mp3"
//    
//    return request
//  }
  
}
