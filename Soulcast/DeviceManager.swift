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
    
    AWSSNS.defaultSNS().createPlatformEndpoint(self.createPlatformEndpointInput(device)).continueWithBlock { (task:AWSTask!) -> AnyObject! in
      if task.error == nil {
        let endpointResponse = task.result as! AWSSNSCreateEndpointResponse
        self.tempDevice.arn = endpointResponse.endpointArn
        self.registerWithServer(self.tempDevice)
      } else if task.error!.domain == AWSSNSErrorDomain{
        if let errorInfo = task.error!.userInfo as NSDictionary! {
          if errorInfo["Code"] as! String == "InvalidParameter" {
            //
          }
        }
      } else {
        self.registerWithServer(self.tempDevice) //!!
        assert(false, "AWSSNS is complaining! To investigate: \(task.error!.description)")
      }
      return nil
      
    }
  }
  
  func registerWithServer(device:Device) {
    request(.POST, serverURL + newDeviceSuffix, parameters: (device.toParams() )).responseJSON { (response: Response<AnyObject, NSError>) in
      switch response.result {
      case .Success:
        print("registerWithServer success")
        // get ID and update to device
      case .Failure:
        print("registerWithServer failure!")
        
      }
    }
  }
  
  func createPlatformEndpointInput(device:Device) -> AWSSNSCreatePlatformEndpointInput{
    let input = AWSSNSCreatePlatformEndpointInput()
    input.token = device.token
    input.platformApplicationArn = SNSPlatformARN
    return input
    
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
      let patchURLString = serverURL + "/api/devices/" + String(deviceID) + ".json"
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
    request(.GET, serverURL + othersQuerySuffix, parameters: (Device.localDevice.toParams() )).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
      //
      switch response.result{
      case .Success:
        completion(response.result.value as! [String:AnyObject])
      case .Failure:
        print("getNearbyDevices fail")
      }

      })
  }
  

}
