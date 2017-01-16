//
//  NumberOfDevicesLabel.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-13.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class NumberOfDevicesLabel: UILabel {
  //
  
  
  override init(frame: CGRect) {
    let minDimension = min(frame.width, frame.height)
    let newFrame = CGRect(x: frame.minX, y: frame.minY, width: minDimension, height: minDimension)
    super.init(frame: newFrame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup() {
    backgroundColor = offBlue
    textAlignment = .center
    font = UIFont(name: HelveticaNeueMedium, size: 20)
    text = "0"
    textColor = UIColor.white
    maskCircle()
    
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addBackgroundShadow()
  }
  
  func addGradient() {
    let topColor = UIColor(red:0.32, green:0.93, blue:0.78, alpha:1.0).cgColor
    let bottomColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0).cgColor
    let rotationPercentage:Float = 0.08
    let a = CGFloat(pow(sinf((6.28*((rotationPercentage+0.75)/2))),2))
    let b = CGFloat(pow(sinf((6.28*((rotationPercentage+0.0)/2))),2))
    let c = CGFloat(pow(sinf((6.28*((rotationPercentage+0.25)/2))),2))
    let d = CGFloat(pow(sinf((6.28*((rotationPercentage+0.5)/2))),2))
    
    
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = bounds
    gradient.colors = [topColor, bottomColor]
    gradient.startPoint = CGPoint(x: a, y: b)
    gradient.endPoint = CGPoint(x: c, y: d)
    layer.addSublayer(gradient)
  }
  
  func maskCircle(){
    let circle = CAShapeLayer()
    let circlePath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: max(bounds.size.width, bounds.size.height))
    circle.path = circlePath.cgPath;
    
    // Configure the apperence of the circle
    
    circle.fillColor = UIColor.yellow.cgColor;
    circle.strokeColor = UIColor.red.cgColor;
    circle.lineWidth = 0;
    
    layer.mask = circle;
    layer.masksToBounds = true
      //
    isUserInteractionEnabled = true
    
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  func addBackgroundShadow() {
    let shadowView = UIView(frame: bounds)
    superview?.insertSubview(shadowView, belowSubview: self)
    shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    let circlePath = UIBezierPath(
      roundedRect: frame,
      cornerRadius: max(bounds.size.width, bounds.size.height))
    shadowView.layer.shadowPath = circlePath.cgPath
    shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
    shadowView.layer.shadowOpacity = 1
    shadowView.layer.shadowRadius = 3
  }
  
  func wiggle() {
    let animation = CABasicAnimation()
    animation.duration = 0.05
    animation.repeatCount = 2
    animation.fromValue = -3
    animation.toValue = 0
    
    self.layer.add(animation, forKey:"transform.translation.x")
  }
}
