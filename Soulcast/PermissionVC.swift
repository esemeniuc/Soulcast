
import Foundation
import UIKit

struct PermissionBehavior {
  let requestAction: ()->()
  let successAction: ()->()
  let failAction: ()->()
}

class PermissionVC: UIViewController {
  
  let permissionRequest: PermissionRequest
  var permissionDescription: String = ""
  let permissionBehavior: PermissionBehavior
  
  init(request:PermissionRequest, behavior:PermissionBehavior ){
    permissionRequest = request
    permissionBehavior = behavior
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
      permissionBehavior.requestAction()
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