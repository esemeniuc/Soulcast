import Foundation
import Alamofire
import AWSSNS

let deviceManager = DeviceManager()

class DeviceManager: NSObject {
  var tempDevice: Device!

  fileprivate func registerDeviceLocally(_ device: Device) {
    UserDefaults.standard.setValue(device.token, forKey: "token")
  }
  
  func register(_ device: Device) { 
    registerDeviceLocally(device)
    tempDevice = device
    registerWithServer(self.tempDevice)
  }
  
  private func registerWithServer(_ device:Device) {
    ServerFacade.post(device, success: { 

      }) { (result) in
        //
    }
  }
  
  func updateLocalDeviceID(_ id:Int) {
    let updatingDevice = Device.localDevice
    updatingDevice.id = id
    Device.localDevice = updatingDevice

  }
  
  func updateDeviceRegion(_ latitude:Double, longitude:Double, radius:Double) {
    let updatingDevice = Device.localDevice
    updatingDevice.latitude = latitude
    updatingDevice.longitude = longitude
    updatingDevice.radius = radius
    Device.localDevice = updatingDevice
    ServerFacade.patch(updatingDevice, success: { 
      //
      print("updateDeviceRegion success!")
      }) { code in
        //
        print("updateDeviceRegion fail")
    }
  }
  
  func getNearbyDevices(_ completion:@escaping ([String:AnyObject])->(), failure:@escaping ()->()) {
    
//    return;
    request(serverURL + nearbySuffix,
      parameters: Device.localDevice.toParams(),
      encoding: JSONEncoding.default,
      headers: ServerFacade.jsonHeader)
      .responseJSON(completionHandler: { response in
        switch response.result{
        case .success:
          completion(response.result.value as! [String:AnyObject])
        case .failure:
          print("getNearbyDevices fail")
          failure()
        }
        
      })
    
  }
  

}
