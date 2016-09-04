
import Foundation
import UIKit

class MockingVC: UIViewController {
  
  let outgoingMockButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  let registerDeviceMockButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  let updateDeviceMockButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  let echoSoulMockButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    setupButtons()
    
  }
  
  func setupButtons() {
    let opacity:CGFloat = 0.6
    outgoingMockButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(opacity)
    registerDeviceMockButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(opacity)
    updateDeviceMockButton.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(opacity)
    echoSoulMockButton.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(opacity)
    
    outgoingMockButton.setupDepression()
    registerDeviceMockButton.setupDepression()
    updateDeviceMockButton.setupDepression()
    echoSoulMockButton.setupDepression()
    
    outgoingMockButton.setTitle("outgoing", forState: .Normal)
    registerDeviceMockButton.setTitle("register", forState: .Normal)
    updateDeviceMockButton.setTitle("update", forState: .Normal)
    echoSoulMockButton.setTitle("echo", forState: .Normal)
    
    outgoingMockButton.addTarget(self, action: #selector(outgoingButtonTapped), forControlEvents: .TouchUpInside)
    registerDeviceMockButton.addTarget(self, action: #selector(registerDeviceButtonTapped), forControlEvents: .TouchUpInside)
    updateDeviceMockButton.addTarget(self, action: #selector(updateDeviceButtonTapped), forControlEvents: .TouchUpInside)
    echoSoulMockButton.addTarget(self, action: #selector(echoSoulButtonTapped), forControlEvents: .TouchUpInside)
    
    put(outgoingMockButton, inside: view, onThe: .Top, withPadding: 50)
    put(registerDeviceMockButton, besideAtThe: .Bottom, of: outgoingMockButton, withSpacing: 50)
    put(updateDeviceMockButton, besideAtThe: .Bottom, of: registerDeviceMockButton, withSpacing: 50)
    put(echoSoulMockButton, besideAtThe: .Bottom, of: updateDeviceMockButton, withSpacing: 50)
  }
  
  func outgoingButtonTapped() {
    print("outgoingButtonTapped()")
    dump(SoulCasterTests.mockSoul())
    ServerFacade.post(SoulCasterTests.mockSoul(), success: { 

    }) { (errorCode) in
        print(errorCode)
    }
  }
  
  func registerDeviceButtonTapped() {
    print("registerDeviceButtonTapped()")
    
    dump(Device.localDevice)
    
    ServerFacade.post(Device.localDevice, success: {
      
    }){ errorCode in
      print(errorCode)
    }
  }
  
  func updateDeviceButtonTapped() {
    print("updateDeviceButtonTapped()")
    ServerFacade.patch(Device.localDevice, success: {
    
    }) { errorCode in
      print(errorCode)
    }
  }
  
  func echoSoulButtonTapped() {
    print("echoSoulButtonTapped()")
    ServerFacade.echo(SoulCasterTests.mockSoul(), success: {
      
    }) { (errorCode) in
      print(errorCode)
    }

  }
  
  
}









