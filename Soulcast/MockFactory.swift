//
//  MockFactory.swift
//  Soulcast
//
//  Created by June Kim on 2017-03-26.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

class MockFactory {
  static func mockSoulOne() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1480719472,
      s3Key: "1479619472",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.234
    newMockSoul.radius = 44.44
//    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
    return newMockSoul
  }
  static func mockSoulTwo() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1481889665,
      s3Key: "1479599118",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.234
    newMockSoul.radius = 44.44
//    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
    return newMockSoul
  }
  static func mockSoulThree() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1481899665,
      s3Key:  "1479612020",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.234
    newMockSoul.radius = 44.44
    newMockSoul.deviceID = 1234
    return newMockSoul
  }
  static func mockSoulFour() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1481900565,
      s3Key: "1479612126",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.23
    newMockSoul.radius = 44.44
    newMockSoul.deviceID = 1324
    return newMockSoul
  }
  static func mockSoulFive() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1481900665,
      s3Key: "fabulousTest",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.23
    newMockSoul.radius = 44.44
    newMockSoul.deviceID = 5432
    return newMockSoul
  }
  
  static func voiceOne() -> Voice {
    return Voice(epoch: 1234, s3Key: "onekeeyyyyy", localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a")
  }
  
  static func voiceTwo() -> Voice {
    return Voice(epoch: 12345, s3Key: "twokeeyyyyy", localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a")
  }
  
  static func voiceThree() -> Voice {
    return Voice(epoch: 123456, s3Key: "threekeeyyyyy", localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a")
  }
  
  static func waveOne() -> Wave {
    return Wave(
      castVoice: voiceOne(),
      callVoice: voiceTwo(),
      replyVoice: voiceThree(),
      casterID: 3,
      callerID: 4,
      type: .reply,
      casterOS: OS.ios,
      callerOS: OS.ios,
      epoch: 432143214321)
  }
}
