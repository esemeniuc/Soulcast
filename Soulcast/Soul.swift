

import UIKit
import TheAmazingAudioEngine


enum SoulType: String {
  case Broadcast = "Broadcast"
  case Outgoing = "Outgoing"
}

class Soul: NSObject {
  var s3Key:String?
  var localURL:String?
  var epoch:Int?
  var longitude:Double?
  var latitude:Double?
  var radius: Double?
  var token: String?
//  var device: Device?
  var type: SoulType?
  
  // Usage: postToServer(someSoul.toParams())
  func toParams(type:SoulType) -> NSDictionary {
    let contentParams = NSMutableDictionary()
    contentParams["type"] = type.rawValue
    contentParams["s3Key"] = s3Key
    contentParams["epoch"] = epoch
    contentParams["longitude"] = longitude
    contentParams["latitude"] = latitude
    contentParams["radius"] = radius
    contentParams["token"] = token
    return contentParams
  }
  
  
  class func from(incomingParams:NSDictionary) -> Soul {
    let contentSoul = Soul()
    contentSoul.type = SoulType(rawValue: incomingParams["type"] as! String)
    contentSoul.s3Key = incomingParams["s3Key"] as? String
    contentSoul.epoch = incomingParams["epoch"] as? Int
    contentSoul.latitude = (incomingParams["latitude"] as! NSString).doubleValue
    contentSoul.longitude = (incomingParams["longitude"] as! NSString).doubleValue
    contentSoul.radius = (incomingParams["radius"] as! NSString).doubleValue
    return contentSoul
  }
  
  func printProperties() {
    print("s3Key: \(s3Key)")
    print("localURL: \(localURL)")
    //TODO:
  }
  
}

class MockFactory {
  static func mockSoulOne() -> Soul {
    let newMockSoul = Soul()
    newMockSoul.s3Key = "helloEricTesting"
    newMockSoul.localURL = "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/A102AB98-3348-4B4B-A4F4-97E2714EB03B/Documents/Recording493417238.887139.m4a"
    newMockSoul.epoch = 493417238
    newMockSoul.longitude = 49.343
    newMockSoul.latitude = 223.234
    newMockSoul.radius = 44.44
    newMockSoul.token = "SOMESAMPLETOKENBLAHBLAH"
    
    return newMockSoul
  }
}
