import Foundation
import Alamofire
import AWSSNS

let deviceManager = DeviceManager()



class DeviceManager: NSObject {
  var tempDevice: Device!

  private func registerDeviceLocally(device: Device) {
    NSUserDefaults.standardUserDefaults().setValue(device.token, forKey: "token")
  }
  
  func register(device: Device) {    //do once per lifetime.
    registerDeviceLocally(device)
    tempDevice = device
    self.registerWithServer(self.tempDevice)
  }
  
  private func registerWithServer(device:Device) {
    ServerFacade.post(device, success: { 
      //
      }) { (result) in
        //
    }
  }
  
  func updateLocalDeviceID(id:Int) {
    let updatingDevice = Device.localDevice
    updatingDevice.id = id
    Device.localDevice = updatingDevice

  }
  
  func updateDeviceRegion(latitude:Double, longitude:Double, radius:Double) {
    let updatingDevice = Device.localDevice
    updatingDevice.latitude = latitude
    updatingDevice.longitude = longitude
    updatingDevice.radius = radius
    Device.localDevice = updatingDevice
    
    if let deviceID = updatingDevice.id {
      let patchURLString = serverURL + "/devices/" + String(deviceID) + ".json"
      request(.PATCH, patchURLString, parameters: (updatingDevice.toParams() )).responseJSON(completionHandler: { (response:Response<AnyObject, NSError>) in
        //
        switch response.result {
        case .Success:
          print("updateDeviceRegion success!")
        case .Failure:
          print("updateDeviceRegion fail")
        }
      })
      
    }
  }
  
  func getNearbyDevices(completion:([String:AnyObject])->()) {
    request(.GET,
      serverURL + nearbySuffix,
      parameters: (Device.localDevice.toParams() ))
      .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
      //TODO:
      switch response.result{
      case .Success:
        completion(response.result.value as! [String:AnyObject])
      case .Failure:
        print("getNearbyDevices fail")
      }

      })
  }
  

}
