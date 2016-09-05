
import Foundation
import UIKit

protocol PermissionVCDelegate {
  func gotPermission(vc:PermissionVC)
  func deniedPermission(vc:PermissionVC)
}

class PermissionVC: UIViewController {
  
  private let permissionTitle: String
  private let permissionDescription: String
  private var titleLabel: UILabel!
  private var descriptionLabel: UILabel!
  var requestAction: () -> ()
  var hasPermission: Bool = false
  
  var delegate: PermissionVCDelegate?
  
  let toggleButton = UISwitch()
  
  init(title:String, description:String, behavior:() -> () ){
    permissionTitle = title
    permissionDescription = description
    requestAction = behavior
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupToggleButton()
    setupLabels()
  }
  
  func setupLabels() {
    titleLabel = UILabel(
      width: CGRectGetWidth(view.bounds),
      height: CGRectGetHeight(view.bounds)*0.1)
    titleLabel.center = CGPointMake(
      CGRectGetMidX(view.bounds),
      CGRectGetMidY(view.bounds) * 0.38)
    titleLabel.textAlignment = .Center
    titleLabel.text = permissionTitle
    titleLabel.font = UIFont(name: HelveticaNeueLight, size: 30)
//    titleLabel.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    view.addSubview(titleLabel)
    
    descriptionLabel = UILabel(
      width: CGRectGetWidth(view.bounds) * 0.85,
      height: CGRectGetHeight(view.bounds)*0.4)
    descriptionLabel.center = CGPointMake(
      CGRectGetMidX(view.bounds),
      CGRectGetMidY(view.bounds))
    descriptionLabel.text = permissionDescription
    descriptionLabel.textAlignment = .Center
    descriptionLabel.font = UIFont(name: HelveticaNeueLight, size: 20)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .ByWordWrapping
//    descriptionLabel.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    view.addSubview(descriptionLabel)
    
  }
  
  func setupToggleButton() {
    toggleButton.addTarget(self, action: #selector(toggleSwitched), forControlEvents: .ValueChanged)
    toggleButton.addTarget(self, action: #selector(toggleTouched), forControlEvents: .TouchDown)
    let toggleYPosition = CGRectGetMaxY(view.bounds)*0.8
    toggleButton.center = CGPoint(x: CGRectGetMidX(view.bounds), y: toggleYPosition)
    view.addSubview(toggleButton)
  }
  
  func toggleTouched(theSwitch: UISwitch) {
    
  }
  
  func switchToggle(turnOn:Bool){
    toggleButton.setOn(turnOn, animated: true)
  }
  
  func toggleSwitched(theSwitch:UISwitch) {
    switch theSwitch.on {
    case true:
      requestAction()
      if !hasPermission { switchToggle(false) }
    case false:
      if hasPermission { switchToggle(true) }
    }
  }
  
  func gotPermission() {
    hasPermission = true
    switchToggle(true)
    self.delegate?.gotPermission(self)
  }
  
  func deniedPermission() {
    hasPermission = false
    switchToggle(false)
    self.delegate?.deniedPermission(self)
  }
  
}

extension PermissionVC: Appearable {
  func didAppearOnScreen(){
    
  }
  func didDisappearFromScreen(){
    
  }
  func willAppearOnScreen(){
    if hasPermission {
      //TODO: handle already has permission.
    }
    
  }
  func willDisappearFromScreen(){
    
  }
}