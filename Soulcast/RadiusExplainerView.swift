//
//  RadiusExplainerView.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-13.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class RadiusExplainerView: UIView {
  let titleString = "Those around you"
  let descriptionString = "This number indicates the number of people around you that will get notified when you cast a soul. This number changes as you adjust your radius by pinching on the map. \n \nJust as they get a push notification when you cast your soul, you will get a push notification when they cast theirs. Pinch to zoom until this number reaches zero to temporarily disable push notifications.  \n \nDirect messaging features coming soon."
  let taglineString = "Please be nice"
  
  
  //
  init(maskCircleArea:CGRect) {
    super.init(frame:CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    setup(maskCircleArea)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup(circleArea:CGRect) {
    //TODO
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    addMask(circleArea)
    addLabels()

  }
  
  func addMask(area:CGRect) {
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
    let circlePath = UIBezierPath(roundedRect: area, cornerRadius: CGRectGetWidth(area)/2)
    path.appendPath(circlePath)
    path.usesEvenOddFillRule = true
    
    let fillLayer = CAShapeLayer()
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = UIColor.darkGrayColor().CGColor
    fillLayer.opacity = 0.8;
    layer.addSublayer(fillLayer)
  }
  
  func addLabels() {
    let titleLabel = UILabel(
      frame: CGRect(
        x: 0,
        y: CGRectGetHeight(bounds) * 0.13,
        width: CGRectGetWidth(bounds),
        height: CGRectGetHeight(bounds)*0.1))
    titleLabel.text = titleString
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.font = UIFont(name: HelveticaNeue, size: 25)
    titleLabel.textAlignment = .Center
    addSubview(titleLabel)
    
    let inset:CGFloat = 30
    let descriptionLabel = UILabel(frame: CGRect(
      x: inset,
      y: CGRectGetMaxY(titleLabel.frame),
      width: CGRectGetWidth(bounds) - 2 * inset,
      height: CGRectGetHeight(bounds) * 0.5))
    descriptionLabel.textColor = UIColor.whiteColor()
    descriptionLabel.text = descriptionString
    descriptionLabel.font = UIFont(name: HelveticaNeue, size: 18)
    descriptionLabel.numberOfLines = 0
    addSubview(descriptionLabel)
    
    let taglineLabel = UILabel(frame: CGRect(
      x: inset,
      y: CGRectGetHeight(bounds)*0.8,
      width: CGRectGetWidth(bounds) - 2 * inset,
      height: CGRectGetHeight(bounds)*0.1))
    taglineLabel.text = taglineString
    taglineLabel.textColor = UIColor.whiteColor()
    taglineLabel.font = UIFont(name: HelveticaNeue, size: 18)
    taglineLabel.textAlignment = .Center
    addSubview(taglineLabel)
  }
  
  func didTap() {
    dismiss()
  }
  
  func dismiss() {
    UIView.animateWithDuration(0.19, animations: {
      self.alpha = 0
      }) { (finished) in
        self.removeFromSuperview()

    }
  }
}