//
//  IncomingCollectionCell.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class IncomingCollectionCell: UICollectionViewCell {

  var radius:Float = 0 {
    didSet {
      let roundedRadius = round(radius*10)/10
      radiusLabel.text = String(roundedRadius) + "km"
    }
  }
  var epoch:Int = 0 {
    didSet {
      timeAgoLabel.text = timeAgo(epoch: epoch)
    }
  }
  fileprivate var radiusLabel:UILabel = UILabel()
  fileprivate var timeAgoLabel: UILabel = UILabel()
  fileprivate var radiusLabelFrame:CGRect!
  fileprivate var timeAgoLabelFrame:CGRect!
  //has a label on the left
  //has a label on the right
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutStuff()
  }
  
  fileprivate func layoutStuff() {
    backgroundColor = UIColor.white
    layoutRadiusLabel()
    layoutTimeAgoLabel()
  }
  
  fileprivate func layoutRadiusLabel() {
    //left middle relative to frame...
    radiusLabelFrame = CGRect(
      x: 5,
      y: 5,
      width: frame.width*0.4,
      height: frame.height*0.8)
    radiusLabel.frame = CGRect.zero
    radiusLabel.font = UIFont(name: HelveticaNeueLight, size: 15)
    radiusLabel.textAlignment = .left
    radiusLabel.textColor = UIColor.darkGray
    radiusLabel.text = "50km"
    contentView.addSubview(radiusLabel)

  }
  
  fileprivate func layoutTimeAgoLabel() {
    //right middle relative to frame...
    let labelWidth = frame.width*0.4
    let labelHeight = frame.height*0.8
    timeAgoLabelFrame = CGRect(
      x: frame.width - labelWidth - 5,
      y: 5,
      width: labelWidth,
      height: labelHeight)
    timeAgoLabel.frame = timeAgoLabelFrame
    timeAgoLabel.font = UIFont(name: HelveticaNeueLight, size: 15)
    timeAgoLabel.textColor = UIColor.darkGray
    timeAgoLabel.textAlignment = .right
    timeAgoLabel.text = "5m"
    contentView.addSubview(timeAgoLabel)
    
    
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.timeAgoLabel.frame = self.timeAgoLabelFrame
    self.radiusLabel.frame = self.radiusLabelFrame
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
}
