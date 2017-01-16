import Foundation

class Device: NSObject {
  var id: Int?
  var token: String? {
    didSet {
      UserDefaults.standard.setValue(token, forKey: "token")
    }
  }
  var longitude: Double?
  var latitude: Double?
  var radius: Double?
  var arn: String?
  
  class var localDevice:Device {
    get{
    let localDevice = Device()
    localDevice.token = UserDefaults.standard.value(forKey: "token") as! String?
    if let locationDictionary: NSDictionary =
    UserDefaults.standard.value(forKey: "locationDictionary") as? NSDictionary {
    localDevice.longitude = locationDictionary["longitude"]as! Double?
    localDevice.latitude = locationDictionary["latitude"] as! Double?
    localDevice.radius = locationDictionary["radius"] as! Double?
    }
    localDevice.id = UserDefaults.standard.value(forKey: "id") as! Int?
    localDevice.arn = UserDefaults.standard.value(forKey: "arn") as! String?
    return localDevice
    }
    set(newValue){
      if let newToken = newValue.token {
        UserDefaults.standard.setValue(newToken, forKey: "token")
      }
      if let newLatitude = newValue.latitude {
        if let newLongitude = newValue.longitude {
          if let newRadius = newValue.radius {
            let locationDictionary = NSMutableDictionary()
            locationDictionary["latitude"] = newLatitude
            locationDictionary["longitude"] = newLongitude
            locationDictionary["radius"] = newRadius
            UserDefaults.standard.setValue(locationDictionary, forKey: "locationDictionary")
          }
        }
      }
      if let newID = newValue.id {
        UserDefaults.standard.setValue(newID, forKey: "id")
      }
      if let newArn = newValue.arn {
        UserDefaults.standard.setValue(newArn, forKey: "arn")
      }
    }
  }
    
  class func from(_ incomingParams: NSDictionary) -> Device{
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
  
  func toParams() -> [String : AnyObject] {
    var params = [String : Any]()
    params["longitude"] = longitude ?? ""
    params["latitude"] = latitude ?? ""
    params["radius"] = radius ?? ""
    params["token"] = token ?? "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    return params as [String : AnyObject]
  }
  

}
