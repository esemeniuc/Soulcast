import Foundation

enum OS: String {
  case ios = "ios"
  case simulator = "simulator"
  case android = "android"
}

class Device {
  static var os: OS = Device.isSimulator ? OS.simulator : OS.ios
  static var id: Int? {
    get {
      if Device.isSimulator {
        return -1
      }
      return UserDefaults.standard.value(forKey: "id") as! Int?
    }
    set { UserDefaults.standard.setValue(newValue, forKey: "id") }
  }
  static var token: String? {
    get { return UserDefaults.standard.value(forKey: "token") as! String? }
    set { UserDefaults.standard.setValue(newValue, forKey: "token") }
  }
  static var longitude: Double? {
    get { return UserDefaults.standard.value(forKey: "longitude") as! Double? }
    set { UserDefaults.standard.setValue(newValue, forKey: "longitude") }
  }
  static var latitude: Double? {
    get { return UserDefaults.standard.value(forKey: "latitude") as! Double? }
    set { UserDefaults.standard.setValue(newValue, forKey: "latitude") }
  }
  static var radius: Double? {
    get { return UserDefaults.standard.value(forKey: "radius") as! Double? }
    set { UserDefaults.standard.setValue(newValue, forKey: "radius") }
  }
  
  class func toParams() -> [String : AnyObject] {
    var params = [String : Any]()
    params["longitude"] = Device.longitude ?? ""
    params["latitude"] = Device.latitude ?? ""
    params["radius"] = Device.radius ?? ""
    params["token"] = Device.token
    params["os"] = Device.os.rawValue
    return params as [String : AnyObject]
  }
 
  static var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
  }
  
}
