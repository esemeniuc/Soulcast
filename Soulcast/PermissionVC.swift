
import Foundation
import UIKit

protocol PermissionVCDelegate: class {
  func gotPermission(_ vc:PermissionVC)
  func deniedPermission(_ vc:PermissionVC)
}

class PermissionVC: UIViewController {
  fileprivate let permissionTitle: String
  fileprivate let permissionDescription: String
  fileprivate var titleLabel: UILabel!
  fileprivate var descriptionLabel: UILabel!
  var requestAction: () -> ()
  var hasPermission: Bool = false
  
  weak var delegate: PermissionVCDelegate?
  
  let toggleButton = UISwitch()
  
  init(title:String, description:String, behavior:@escaping () -> () ){
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
      width: view.bounds.width,
      height: view.bounds.height*0.1)
    titleLabel.center = CGPoint(
      x: view.bounds.midX,
      y: view.bounds.midY * 0.38)
    titleLabel.textAlignment = .center
    titleLabel.text = permissionTitle
    titleLabel.font = UIFont(name: HelveticaNeueLight, size: 30)
//    titleLabel.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    view.addSubview(titleLabel)
    
    descriptionLabel = UILabel(
      width: view.bounds.width * 0.85,
      height: view.bounds.height*0.4)
    descriptionLabel.center = CGPoint(
      x: view.bounds.midX,
      y: view.bounds.midY)
    descriptionLabel.text = permissionDescription
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = UIFont(name: HelveticaNeueLight, size: 20)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
//    descriptionLabel.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    view.addSubview(descriptionLabel)
    
  }
  
  func setupToggleButton() {
    toggleButton.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
    toggleButton.addTarget(self, action: #selector(toggleTouched), for: .touchDown)
    let toggleYPosition = view.bounds.maxY*0.8
    toggleButton.center = CGPoint(x: view.bounds.midX, y: toggleYPosition)
    view.addSubview(toggleButton)
  }
  
  func toggleTouched(_ theSwitch: UISwitch) {
    theSwitch.isEnabled = false
    let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      theSwitch.isEnabled = true
    }
  }
  
  func switchToggle(_ turnOn:Bool){
    if hasPermission {
      self.delegate?.gotPermission(self)
    }
      toggleButton.setOn(turnOn, animated: true)
    
  }
  
  func toggleSwitched(_ theSwitch:UISwitch) {
    switch theSwitch.isOn {
    case true:
      requestAction()
      if !hasPermission { switchToggle(false) }
    case false:
      if hasPermission { switchToggle(true) }
    }
  }
  
  func gotPermission() {
    hasPermission = true
    if !toggleButton.isOn {
      switchToggle(true)
    }
    
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
