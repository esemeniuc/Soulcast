
import Foundation
import UIKit

class MockingVC: UIViewController {
  
  let outgoingMockButton = UIButton(width: 100, height: 100)
  let registerDeviceMockButton = UIButton(width: 100, height: 100)
  let updateDeviceMockButton = UIButton(width: 100, height: 100)
  let echoSoulMockButton = UIButton(width: 100, height: 100)
  
  let failView = UIView(width: screenWidth * 0.85, height: screenHeight * 0.85)
  let failLabel = UILabel(width: screenWidth * 0.65, height: screenHeight * 0.3)
  
  let successView = UIView(width: screenWidth * 0.85, height: screenHeight * 0.85)
  let successLabel = UILabel(width: screenWidth * 0.65, height: screenHeight * 0.3)
  
  var serverField:UITextField!
  var backgroundTapRecognizer:UITapGestureRecognizer!
  
  var failString = "FAIL" {
    didSet{
      failLabel.text = failString
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()
    setupButtons()
    setupFailView()
    setupSuccessView()
    setupServerChanger()
  }
  
  func setupServerChanger() {
    serverField = UITextField(width: CGRectGetWidth(view.bounds), height: 70)
    serverField.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
    serverField.delegate = self
    serverField.textAlignment = .Center
    serverField.placeholder = "http://________.localtunnel.me"
    serverField.autocorrectionType = .No
    serverField.autocapitalizationType = .None
    view.addSubview(serverField)
    
    backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
    view.addGestureRecognizer(backgroundTapRecognizer)
    
    disableButtons()
  }
  
  func didTapBackground() {
    serverField.endEditing(true)
  }
  
  func didFinishEditing() {
    enableButtons()
    
    UIView.animateWithDuration(0.5, animations: {
      self.serverField.center = CGPointMake(CGRectGetMidX(self.serverField.frame), CGRectGetMidY(self.serverField.frame) - CGRectGetHeight(self.serverField.frame))
    }) { (finished) in
      self.serverField.hidden = true
    }

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  func setupFailView() {
    failView.backgroundColor = UIColor.redColor()
    failView.layer.opacity = 0
    failLabel.textAlignment = .Center
    failLabel.font = UIFont(name: "Helvetica", size: 30)
    failLabel.adjustsFontSizeToFitWidth = true
    failLabel.textColor = UIColor.whiteColor()
    failLabel.text = failString
    failView.addSubview(failLabel)
    failView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    failLabel.center = CGPoint(x: CGRectGetMidX(failView.bounds), y: CGRectGetMidY(failView.bounds))
    failView.userInteractionEnabled = false
  }
  
  func setupSuccessView() {
    successView.backgroundColor = UIColor.greenColor()
    successView.layer.opacity = 0
    successLabel.textColor = UIColor.whiteColor()
    successLabel.font = UIFont(name: "Helvetica", size: 40)
    successLabel.text = "SUCCCESS"
    successLabel.adjustsFontSizeToFitWidth = true
    successView.addSubview(successLabel)
    successView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    successLabel.center = CGPoint(x: CGRectGetMidX(failView.bounds), y: CGRectGetMidY(failView.bounds))
    successView.userInteractionEnabled = false
  }
  
  func updateFailForCode(code:Int) {
    failString = NSHTTPURLResponse.localizedStringForStatusCode(code)
    flash(failView)
  }

  func flash(flashee:UIView) {
    view.addSubview(flashee)
    UIView.animateWithDuration(0.8, animations: {
      flashee.layer.opacity = 1
    }) { (completed) in
      UIView.animateWithDuration(0.6, animations: {
        flashee.layer.opacity = 0
        }, completion: { (completed) in
          flashee.removeFromSuperview()
      })
    }
  }
  
  func disableButtons() {
    outgoingMockButton.enabled = false
    registerDeviceMockButton.enabled = false
    updateDeviceMockButton.enabled = false
    echoSoulMockButton.enabled = false
  }
  
  func enableButtons() {
    outgoingMockButton.enabled = true
    registerDeviceMockButton.enabled = true
    updateDeviceMockButton.enabled = true
    echoSoulMockButton.enabled = true
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
    disableButtons()
    ServerFacade.post(SoulCasterTests.mockSoul(), success: { 
      self.flash(self.successView)
      self.enableButtons()
    }) { (errorCode) in
        print(errorCode)
      self.updateFailForCode(errorCode)
      self.enableButtons()
    }
  }
  
  func registerDeviceButtonTapped() {
    print("registerDeviceButtonTapped()")
    
    dump(Device.localDevice)
    disableButtons()
    ServerFacade.post(Device.localDevice, success: {
      self.flash(self.successView)
      self.enableButtons()
    }){ errorCode in
      print(errorCode)
      self.updateFailForCode(errorCode)
      self.enableButtons()
    }
  }
  
  func updateDeviceButtonTapped() {
    print("updateDeviceButtonTapped()")
    disableButtons()
    ServerFacade.patch(Device.localDevice, success: {
      self.flash(self.successView)
      self.enableButtons()
    }) { errorCode in
      print(errorCode)
      self.updateFailForCode(errorCode)
      self.enableButtons()
    }
  }
  
  func echoSoulButtonTapped() {
    print("echoSoulButtonTapped()")
    disableButtons()
    ServerFacade.echo(SoulCasterTests.mockSoul(), success: {
      self.flash(self.successView)
      self.enableButtons()
    }) { (errorCode) in
      print(errorCode)
      self.updateFailForCode(errorCode)
      self.enableButtons()
    }

  }
  
  
  
}




extension MockingVC: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    serverURL = "http://" + textField.text! + ".localtunnel.me"
    print(serverURL)
    didFinishEditing()
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
        serverField.endEditing(true)
    return true
  }
}




