import Foundation

class Device: NSObject {
  var id: Int?
  var token: String?
  var longitude: Double?
  var latitude: Double?
  var radius: Double?
  var arn: String?
  
  class var localDevice:Device {
    get{
    let localDevice = Device()
    localDevice.token = NSUserDefaults.standardUserDefaults().valueForKey("token") as! String?
    if let locationDictionary: NSDictionary =
    NSUserDefaults.standardUserDefaults().valueForKey("locationDictionary") as? NSDictionary {
    localDevice.longitude = locationDictionary["longitude"]as! Double?
    localDevice.latitude = locationDictionary["latitude"] as! Double?
    localDevice.radius = locationDictionary["radius"] as! Double?
    }
    localDevice.id = NSUserDefaults.standardUserDefaults().valueForKey("id") as! Int?
    localDevice.arn = NSUserDefaults.standardUserDefaults().valueForKey("arn") as! String?
    return localDevice
    }
    set(newValue){
      if let newToken = newValue.token {
        NSUserDefaults.standardUserDefaults().setValue(newToken, forKey: "token")
      }
      if let newLatitude = newValue.latitude {
        if let newLongitude = newValue.longitude {
          if let newRadius = newValue.radius {
            let locationDictionary = NSMutableDictionary()
            locationDictionary["latitude"] = newLatitude
            locationDictionary["longitude"] = newLongitude
            locationDictionary["radius"] = newRadius
            NSUserDefaults.standardUserDefaults().setValue(locationDictionary, forKey: "locationDictionary")
          }
        }
      }
      if let newID = newValue.id {
        NSUserDefaults.standardUserDefaults().setValue(newID, forKey: "id")
      }
      if let newArn = newValue.arn {
        NSUserDefaults.standardUserDefaults().setValue(newArn, forKey: "arn")
      }
    }
  }
    
  class func from(incomingParams: NSDictionary) -> Device{
    let incomingDevice = Device()
    if incomingParams["type"] as? String == "incoming" {
      if let contentParams = incomingParams["device"] as? NSDictionary {
        incomingDevice.token = contentParams["token"] as? String
        incomingDevice.longitude = contentParams["longitude"] as? Double
        incomingDevice.latitude = contentParams["latitude"] as? Double
        incomingDevice.radius = contentParams["radius"] as? Double
        incomingDevice.arn = contentParams["arn"] as? String
      }
    }
    
    return Device()
  }
  
  func toParams() -> NSDictionary {
    let wrapperParams = NSMutableDictionary()
    let contentParams = NSMutableDictionary()
    wrapperParams["device"] = contentParams
    if token != nil { contentParams["token"] = token }
    if longitude != nil { contentParams["longitude"] = longitude }
    if latitude != nil { contentParams["latitude"] = latitude }
    if radius != nil { contentParams["radius"] = radius }
    if id != nil { contentParams["id"] = id }
    if arn != nil { contentParams["arn"] = arn }
    return wrapperParams
  }
  

}
