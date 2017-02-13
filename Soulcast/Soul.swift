//

import UIKit
import TheAmazingAudioEngine


enum SoulType: String {
  case Broadcast = "Broadcast"
  case Improve = "Improve"
  case Direct = "Direct"
}

class Soul: NSObject {
  var voice:Voice
  var longitude:Double?
  var latitude:Double?
  var radius: Double?
  var token: String? // = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
//  var device: Device?
  var type: SoulType = .Broadcast
  
  init(voice:Voice) {
    self.voice = voice
    super.init()
  }
  
  // Usage: postToServer(someSoul.toParams())
  func toParams() -> [String : AnyObject] {
    var params = [String : Any]()
    params["s3Key"] = voice.s3Key
    params["epoch"] = voice.epoch
    params["longitude"] = longitude
    params["latitude"] = latitude
    params["radius"] = radius
    params["token"] = token
    return params as [String : AnyObject]
  }
  
  
  class func fromAPNSHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(
      voice: Voice(
        epoch: soulHash["epoch"] as! Int,
        s3Key: soulHash["s3Key"] as? String,
        localURL: nil))
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSNumber)?.doubleValue
    return incomingSoul
  }
  
  class func fromHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(voice: Voice(
      epoch: soulHash["soul[epoch]"] as! Int,
      s3Key: soulHash["soul[s3Key]"] as? String,
      localURL: nil))
    incomingSoul.latitude = (soulHash["soul[latitude]"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["soul[longitude]"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["soul[radius]"] as? NSNumber)?.doubleValue
    incomingSoul.token = soulHash["soul[token]"] as? String
    return incomingSoul
  }
  
  class func fromArray (_ soulsJSON: [[String: AnyObject]]) -> [Soul] {
    var souls = [Soul]()
    for eachSoulJson in soulsJSON {
      souls.append(fromServerHash(eachSoulJson as NSDictionary))
    }
    return souls
  }
  
  class func fromServerHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(voice: Voice(
      epoch: soulHash["epoch"] as! Int,
      s3Key: soulHash["s3Key"] as? String,
      localURL: nil))
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSNumber)?.doubleValue
    incomingSoul.token = soulHash["token"] as? String
    return incomingSoul
  }
  
  
}

class MockFactory {
  static func mockSoulOne() -> Soul {
    let newMockSoul = Soul(voice: Voice(
      epoch: 1480719472,
      s3Key: "1479619472",
      localURL: "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"))
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.234
    newMockSoul.radius = 44.44
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
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
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
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
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
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
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
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
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
    return newMockSoul
  }
}
