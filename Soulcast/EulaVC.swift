//
//  EulaVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-10-15.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol EulaVCDelegate: class {
  func didTapOKButton(vc:EulaVC)
}

class EulaVC: UIViewController {
  var agreementString:String {
    var content = ""
    if let path = NSBundle.mainBundle().pathForResource("eula", ofType: "txt"){
      do {try content = String(contentsOfFile: path, encoding: NSUTF8StringEncoding) }
      catch {}
    }
    return content
    
  }
  let okButton = UIButton(type: .System)
  let eulaContainerView = UIView()
  let eulaTextView = UITextView()
  weak var delegate: EulaVCDelegate?
  
  override func viewDidLoad() {
    let margin:CGFloat = 15
    okButton.setTitle("Agree", forState: .Normal)
    let buttonWidth:CGFloat = 100
    let buttonHeight:CGFloat = 50
    okButton.frame = CGRect(
      x: (screenWidth - buttonWidth)/2,
      y: screenHeight - buttonHeight - margin,
      width: buttonWidth, height: buttonHeight)
    okButton.addTarget(self, action: #selector(okButtonTapped), forControlEvents: .TouchUpInside)
    
    
    eulaContainerView.frame = CGRect(
      x: margin,
      y: margin,
      width: screenWidth - 2*margin,
      height: screenHeight - 3*margin - buttonHeight)
    view.addSubview(eulaContainerView)

    eulaTextView.text = agreementString
    eulaTextView.editable = false
    eulaTextView.scrollEnabled = true
    eulaContainerView.addSubview(eulaTextView)
    
    view.addSubview(okButton)
  }
  
  
  func okButtonTapped() {
    okButton.enabled = false
    delegate?.didTapOKButton(self)
  }
  
  
}
