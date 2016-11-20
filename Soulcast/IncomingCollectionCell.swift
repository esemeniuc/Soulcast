//
//  IncomingCollectionCell.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol IncomingCollectionCellDelegate: class {
  func didTapReport()
}

class IncomingCollectionCell: UICollectionViewCell {

  var reportButton:UIButton!
  weak var delegate:IncomingCollectionCellDelegate?
  
  var radius:Float = 0 {
    didSet {
      let roundedRadius = round(radius*10)/10
      radiusLabel.text = String(roundedRadius) + "km"
    }
  }
  var timeAgo:Int = 0 {
    didSet {
      timeAgoLabel.text = timeAgoSince(NSDate(timeIntervalSince1970: NSTimeInterval(timeAgo)))
    }
  }
  private var radiusLabel:UILabel = UILabel()
  private var timeAgoLabel: UILabel = UILabel()
  private var radiusLabelFrame:CGRect!
  private var timeAgoLabelFrame:CGRect!
  //has a label on the left
  //has a label on the right
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutStuff()
  }
  
  private func layoutStuff() {
    backgroundColor = UIColor.whiteColor()
    layoutRadiusLabel()
    layoutTimeAgoLabel()
    addReportButton()
  }
  
  private func layoutRadiusLabel() {
    //left middle relative to frame...
    radiusLabelFrame = CGRect(
      x: 5,
      y: 5,
      width: CGRectGetWidth(frame)*0.4,
      height: CGRectGetHeight(frame)*0.8)
    radiusLabel.frame = CGRectZero
    radiusLabel.font = UIFont(name: HelveticaNeueLight, size: 15)
    radiusLabel.textAlignment = .Left
    radiusLabel.textColor = UIColor.darkGrayColor()
    radiusLabel.text = "50km"
    contentView.addSubview(radiusLabel)

  }
  
  private func layoutTimeAgoLabel() {
    //right middle relative to frame...
    let labelWidth = CGRectGetWidth(frame)*0.4
    let labelHeight = CGRectGetHeight(frame)*0.8
    timeAgoLabelFrame = CGRect(
      x: CGRectGetWidth(frame) - labelWidth - 5,
      y: 5,
      width: labelWidth,
      height: labelHeight)
    timeAgoLabel.frame = timeAgoLabelFrame
    timeAgoLabel.font = UIFont(name: HelveticaNeueLight, size: 15)
    timeAgoLabel.textColor = UIColor.darkGrayColor()
    timeAgoLabel.textAlignment = .Right
    timeAgoLabel.text = "5m"
    contentView.addSubview(timeAgoLabel)
    
    
  }
  
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    UIView.animateWithDuration(5) { 
      self.timeAgoLabel.frame = self.timeAgoLabelFrame
      self.radiusLabel.frame = self.radiusLabelFrame

    }
  }
  
  private func addReportButton() {
    reportButton = UIButton(type:.System)
    reportButton.setTitle("Report", forState: .Normal)
    reportButton.setTitleColor(UIColor.redColor(), forState: .Normal)
    reportButton.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.3), forState: .Disabled)
    reportButton.frame = CGRect(
      x: 0,
      y: 0,
      width: 100,
      height: self.contentView.height)
    reportButton.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(radiusLabelFrame))
    contentView.addSubview(reportButton)
    reportButton.enabled = false
    reportButton.addTarget(self, action: #selector(reportButtonTapped), forControlEvents: .TouchUpInside)
  }
  
  func showReportButton() {
    reportButton.enabled = true
  }
  
  func hideReportButton() {
    reportButton.enabled = false
  }
  
  func reportButtonTapped() {
    hideReportButton()
    delegate?.didTapReport()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
}
