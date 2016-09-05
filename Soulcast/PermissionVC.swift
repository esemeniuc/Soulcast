
import Foundation
import UIKit

protocol PermissionVCDelegate {
  func didGetPermission(type:Permission)
}

enum Permission: String {
  case Push = "Push Notification"
  case Microphone = "Microphone Access"
  case Location = "Location Permission"
}

class PermissionVC: UIViewController {
  static let pushDescription = "To be able to listen to those around you, we need to be able to send you push notifications"
  static let microphoneDescription = "To be able to cast your voice to those around you, we need microphone access"
  static let locationDescription = "This is a location-based app. We need your location so that you can catch souls around you"
  
  let permissionType: Permission
  var permissionDescription: String = ""
  let permissionAction: () -> ()
  
  var delegate: PermissionVCDelegate?
  
  init(type:Permission, action: () -> ()){
    permissionType = type
    permissionAction = action
    switch permissionType {
    case .Push:
      permissionDescription = PermissionVC.pushDescription
    case .Microphone:
      permissionDescription = PermissionVC.microphoneDescription
    case .Location:
      permissionDescription = PermissionVC.locationDescription
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupToggleButton()
  }
  
  func setupToggleButton() {
    let toggleButton = UISwitch()
    toggleButton.addTarget(self, action: #selector(toggleSwitched), forControlEvents: .ValueChanged)
    toggleButton.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    view.addSubview(toggleButton)
  }
  
  func toggleSwitched(theSwitch:UISwitch) {
    if theSwitch.on {
      //
      permissionAction()
      //TODO: upon permission granted, perform delegate?.didGetPermission(permissionType)
      //
    } else {
      //
    }
  }
  
  
}

extension PermissionVC: Appearable {
  /// called when the view finish decelerating onto the screen.
  func didAppearOnScreen(){
    
  }
  /// called when the view finish decelerating off the screen.
  func didDisappearFromScreen(){
    
  }
  /// called when the view begin decelerating onto the screen.
  func willAppearOnScreen(){
    
  }
  /// called when the view begin decelerating off the screen.
  func willDisappearFromScreen(){
    
  }
}