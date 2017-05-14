//

import UIKit


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
//  var token: String? // = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  var deviceID: Int?
  var os: OS = OS.ios
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
    //params["token"] = token
    params["deviceID"] = deviceID
    return params as [String : AnyObject]
  }
  
  
  static func fromAPNSHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(
      voice: Voice(
        epoch: soulHash["epoch"] as! Int,
        s3Key: soulHash["s3Key"] as? String,
        localURL: nil))
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSNumber)?.doubleValue
    incomingSoul.deviceID = (soulHash["deviceID"] as? NSNumber)?.intValue
    return incomingSoul
  }
  
  static func fromHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(voice: Voice(
      epoch: soulHash["soul[epoch]"] as! Int,
      s3Key: soulHash["soul[s3Key]"] as? String,
      localURL: nil))
    incomingSoul.latitude = (soulHash["soul[latitude]"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["soul[longitude]"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["soul[radius]"] as? NSNumber)?.doubleValue
    incomingSoul.deviceID = (soulHash["soul[deviceID]"] as? NSNumber)?.intValue
    
    return incomingSoul
  }
  
  static func fromArray (_ soulsJSON: [[String: AnyObject]]) -> [Soul] {
    var souls = [Soul]()
    for eachSoulJson in soulsJSON {
      souls.append(fromServerHash(eachSoulJson as NSDictionary))
    }
    return souls
  }
  
  static func fromServerHash (_ soulHash:NSDictionary) -> Soul {
    let incomingSoul = Soul(voice: Voice(
      epoch: soulHash["epoch"] as! Int,
      s3Key: soulHash["s3Key"] as? String,
      localURL: nil))
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSNumber)?.doubleValue
    incomingSoul.deviceID = (soulHash["deviceID"] as? NSNumber)?.intValue
    return incomingSoul
  }
  
  
}
