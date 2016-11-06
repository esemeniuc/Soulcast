//

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
  func toParams() -> [String : AnyObject] {
    return [
//    contentParams["soul[soulType]"] = type!.rawValue
    "s3Key": s3Key ?? "",
    "epoch": epoch ?? "",
    "longitude": longitude ?? "",
    "latitude": latitude ?? "",
    "radius": radius ?? "",
    "token": token ?? "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"]
  }
  
  
  class func fromAPNSHash (soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul()
    let incomingDevice = Device()
    incomingDevice.id = soulHash["device_id"] as? Int
    //    incomingSoul.device = incomingDevice
    incomingSoul.epoch = soulHash["epoch"] as? Int
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSNumber)?.doubleValue
    incomingSoul.s3Key = soulHash["s3Key"] as? String
    return incomingSoul
  }
  
  class func fromHash (soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul()
    let incomingDevice = Device()
    incomingDevice.id = soulHash["soul[device_id]"] as? Int
    //    incomingSoul.device = incomingDevice
    incomingSoul.epoch = soulHash["soul[epoch]"] as? Int
    incomingSoul.latitude = (soulHash["soul[latitude]"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["soul[longitude]"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["soul[radius]"] as? NSNumber)?.doubleValue
    incomingSoul.s3Key = soulHash["soul[s3Key]"] as? String
    return incomingSoul
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
