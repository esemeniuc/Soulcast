//
//  ImproveButton.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-12.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class ImproveButton: UIButton {
  let buttonSize:CGFloat = 50
  let margin:CGFloat = 25
  
  override init(frame: CGRect) {
    assert(frame == CGRect.zero)
    super.init(frame: CGRect(
      x: screenWidth - buttonSize - margin,
      y: screenHeight - buttonSize - margin,
      width: buttonSize,
      height: buttonSize))
    
    backgroundColor = offBlue
    setTitleColor(UIColor.black, for: UIControlState())
    let italicFont = UIFont(name: "Baskerville-BoldItalic", size: 15)!
    let attributedTitle = NSAttributedString(string: "i", attributes: (NSDictionary(object: italicFont, forKey: NSFontAttributeName as NSCopying) as! [String : AnyObject]))
    
    setAttributedTitle(attributedTitle, for: UIControlState())
    clipsToBounds = false
    layer.cornerRadius = buttonSize/2
    

  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    alpha = 0
    UIView.animate(withDuration: 1, animations: {
      self.alpha = 1
    }) 
    let shadowView = UIView(frame: bounds)
    let circlePath = UIBezierPath(
      roundedRect: frame,
      cornerRadius: layer.cornerRadius)
    shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    shadowView.layer.shadowPath = circlePath.cgPath
    shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
    shadowView.layer.shadowOpacity = 1
    shadowView.layer.shadowRadius = 6
    layer.superlayer?.insertSublayer(shadowView.layer, below: layer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
