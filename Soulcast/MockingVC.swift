
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
  
  var tempSoulCatcher: SoulCatcher?
  
  var failString = "FAIL" {
    didSet{
      failLabel.text = failString
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    setupButtons()
    setupFailView()
    setupSuccessView()
    setupServerChanger()
  }
  
  func setupServerChanger() {
    serverField = UITextField(width: view.bounds.width, height: 70)
    serverField.backgroundColor = UIColor.black.withAlphaComponent(0.15)
    serverField.delegate = self
    serverField.textAlignment = .center
    serverField.placeholder = "http://________.localtunnel.me"
    serverField.autocorrectionType = .no
    serverField.autocapitalizationType = .none
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
    
    UIView.animate(withDuration: 0.5, animations: {
      self.serverField.center = CGPoint(x: self.serverField.frame.midX, y: self.serverField.frame.midY - self.serverField.frame.height)
    }, completion: { (finished) in
      self.serverField.isHidden = true
    }) 

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  func setupFailView() {
    failView.backgroundColor = UIColor.red
    failView.layer.opacity = 0
    failLabel.textAlignment = .center
    failLabel.font = UIFont(name: "Helvetica", size: 30)
    failLabel.adjustsFontSizeToFitWidth = true
    failLabel.textColor = UIColor.white
    failLabel.text = failString
    failView.addSubview(failLabel)
    failView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    failLabel.center = CGPoint(x: failView.bounds.midX, y: failView.bounds.midY)
    failView.isUserInteractionEnabled = false
  }
  
  func setupSuccessView() {
    successView.backgroundColor = UIColor.green
    successView.layer.opacity = 0
    successLabel.textColor = UIColor.white
    successLabel.font = UIFont(name: "Helvetica", size: 40)
    successLabel.text = "SUCCCESS"
    successLabel.adjustsFontSizeToFitWidth = true
    successView.addSubview(successLabel)
    successView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    successLabel.center = CGPoint(x: failView.bounds.midX, y: failView.bounds.midY)
    successView.isUserInteractionEnabled = false
  }
  
  func updateFailForCode(_ code:Int) {
    failString = HTTPURLResponse.localizedString(forStatusCode: code)
    flash(failView)
  }

  func flash(_ flashee:UIView) {
    view.addSubview(flashee)
    UIView.animate(withDuration: 0.8, animations: {
      flashee.layer.opacity = 1
    }, completion: { (completed) in
      UIView.animate(withDuration: 0.6, animations: {
        flashee.layer.opacity = 0
        }, completion: { (completed) in
          flashee.removeFromSuperview()
      })
    }) 
  }
  
  func disableButtons() {
    outgoingMockButton.isEnabled = false
    registerDeviceMockButton.isEnabled = false
    updateDeviceMockButton.isEnabled = false
    echoSoulMockButton.isEnabled = false
  }
  
  func enableButtons() {
    outgoingMockButton.isEnabled = true
    registerDeviceMockButton.isEnabled = true
    updateDeviceMockButton.isEnabled = true
    echoSoulMockButton.isEnabled = true
  }
  
  func setupButtons() {
    let opacity:CGFloat = 0.6
    outgoingMockButton.backgroundColor = UIColor.blue.withAlphaComponent(opacity)
    registerDeviceMockButton.backgroundColor = UIColor.red.withAlphaComponent(opacity)
    updateDeviceMockButton.backgroundColor = UIColor.orange.withAlphaComponent(opacity)
    echoSoulMockButton.backgroundColor = UIColor.green.withAlphaComponent(opacity)
    
    outgoingMockButton.setupDepression()
    registerDeviceMockButton.setupDepression()
    updateDeviceMockButton.setupDepression()
    echoSoulMockButton.setupDepression()
    
    outgoingMockButton.setTitle("outgoing", for: UIControlState())
    registerDeviceMockButton.setTitle("register", for: UIControlState())
    updateDeviceMockButton.setTitle("update", for: UIControlState())
    echoSoulMockButton.setTitle("echo", for: UIControlState())
    
    outgoingMockButton.addTarget(self, action: #selector(outgoingButtonTapped), for: .touchUpInside)
    registerDeviceMockButton.addTarget(self, action: #selector(registerDeviceButtonTapped), for: .touchUpInside)
    updateDeviceMockButton.addTarget(self, action: #selector(updateDeviceButtonTapped), for: .touchUpInside)
    echoSoulMockButton.addTarget(self, action: #selector(echoSoulButtonTapped), for: .touchUpInside)
    
    put(outgoingMockButton, inside: view, onThe: .top, withPadding: 50)
    put(registerDeviceMockButton, besideAtThe: .bottom, of: outgoingMockButton, withSpacing: 50)
    put(updateDeviceMockButton, besideAtThe: .bottom, of: registerDeviceMockButton, withSpacing: 50)
    put(echoSoulMockButton, besideAtThe: .bottom, of: updateDeviceMockButton, withSpacing: 50)
  }
  
  func outgoingButtonTapped() {
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
    disableButtons()
    
    ServerFacade.postDevice( success: {
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
    ServerFacade.patchDevice(success: {
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
      soul in
      self.flash(self.successView)
      self.enableButtons()
      self.tempSoulCatcher = SoulCatcher(soul:soul)
      self.tempSoulCatcher!.delegate = self
    }) { (errorCode) in
      print(errorCode)
      self.updateFailForCode(errorCode)
      self.enableButtons()
    }

  }
  
  
  
}


extension MockingVC: SoulCatcherDelegate {
  func soulDidStartToDownload(_ catcher:SoulCatcher, soul:Soul) {
  
  }
  func soulIsDownloading(_ catcher:SoulCatcher, progress:Float) {
  
  }
  func soulDidFinishDownloading(_ catcher:SoulCatcher, soul:Soul) {
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload(_ catcher:SoulCatcher) {
  
  }
}

extension MockingVC: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    serverURL = "http://" + textField.text! + ".localtunnel.me"
    print(serverURL)
    didFinishEditing()
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serverField.endEditing(true)
    return true
  }
}




