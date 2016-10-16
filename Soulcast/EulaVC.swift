//
//  EulaVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-10-15.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol EulaVCDelegate {
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
  var delegate: EulaVCDelegate?
  
  override func viewDidLoad() {
    let margin:CGFloat = 25
    okButton.setTitle("Agree", forState: .Normal)
    let buttonWidth:CGFloat = 100
    let buttonHeight:CGFloat = 50
    okButton.frame = CGRectMake(
      (screenWidth - buttonWidth)/2,
      screenHeight - buttonHeight - margin,
      buttonWidth, buttonHeight)
    okButton.addTarget(self, action: #selector(okButtonTapped), forControlEvents: .TouchUpInside)
    
    
    eulaContainerView.frame = CGRectMake(
      margin,
      margin,
      screenWidth - 2*margin,
      screenHeight - 3*margin - buttonHeight)
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
