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
    let minDimension = min(CGRectGetWidth(frame), CGRectGetHeight(frame))
    let newFrame = CGRect(x: CGRectGetMinX(frame), y: CGRectGetMinY(frame), width: minDimension, height: minDimension)
    super.init(frame: newFrame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup() {
    backgroundColor = offBlue
    textAlignment = .Center
    font = UIFont(name: HelveticaNeueMedium, size: 20)
    text = "0"
    textColor = UIColor.whiteColor()
    maskCircle()
    
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addBackgroundShadow()
  }
  
  func addGradient() {
    let topColor = UIColor(red:0.32, green:0.93, blue:0.78, alpha:1.0).CGColor
    let bottomColor = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0).CGColor
    let rotationPercentage:Float = 0.08
    let a = CGFloat(pow(sinf((6.28*((rotationPercentage+0.75)/2))),2))
    let b = CGFloat(pow(sinf((6.28*((rotationPercentage+0.0)/2))),2))
    let c = CGFloat(pow(sinf((6.28*((rotationPercentage+0.25)/2))),2))
    let d = CGFloat(pow(sinf((6.28*((rotationPercentage+0.5)/2))),2))
    
    
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = bounds
    gradient.colors = [topColor, bottomColor]
    gradient.startPoint = CGPointMake(a, b)
    gradient.endPoint = CGPointMake(c, d)
    layer.addSublayer(gradient)
  }
  
  func maskCircle(){
    let circle = CAShapeLayer()
    let circlePath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: max(bounds.size.width, bounds.size.height))
    circle.path = circlePath.CGPath;
    
    // Configure the apperence of the circle
    
    circle.fillColor = UIColor.yellowColor().CGColor;
    circle.strokeColor = UIColor.redColor().CGColor;
    circle.lineWidth = 0;
    
    layer.mask = circle;
    layer.masksToBounds = true
      //
    userInteractionEnabled = true
    
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  func addBackgroundShadow() {
    let shadowView = UIView(frame: bounds)
    superview?.insertSubview(shadowView, belowSubview: self)
    shadowView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor
    let circlePath = UIBezierPath(
      roundedRect: frame,
      cornerRadius: max(bounds.size.width, bounds.size.height))
    shadowView.layer.shadowPath = circlePath.CGPath
    shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
    shadowView.layer.shadowOpacity = 1
    shadowView.layer.shadowRadius = 3
  }
  
  func wiggle() {
    //TODO: animate.
    let animation = CABasicAnimation()
    animation.duration = 0.05
    animation.repeatCount = 2
    animation.fromValue = -3
    animation.toValue = 0
    
    self.layer.addAnimation(animation, forKey:"transform.translation.x")
  }
}
