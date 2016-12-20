//
//  PageTab.swift
//  Soulcast
//
//  Created by June Kim on 2016-12-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

enum PageDirection {
  case Left
  case Right
}

class PageTab: UIView {
  
  convenience init(direction:PageDirection) {
    let tabWidth:CGFloat = 40
    let tabHeight:CGFloat = 100
    let arrowWidth: CGFloat = 25
    let pageTab = UIView()
    pageTab.backgroundColor = UIColor.darkGrayColor()
    pageTab.layer.cornerRadius = 5
    switch direction {
    case .Left:
      self.init(frame: CGRect(
        x: 0,
        y: (screenHeight - tabHeight)/2,
        width: tabWidth/2,
        height: tabHeight))
      pageTab.frame = CGRect(
        x: -tabWidth/2,
        y: 0,
        width: tabWidth,
        height: tabHeight)
      let leftArrowImage = UIImage(named: "ios7-arrow-left")
      let leftArrowView = UIImageView(image: leftArrowImage)
      leftArrowView.frame = CGRect(
        x: tabWidth - arrowWidth,
        y: (tabHeight - arrowWidth)/2,
        width: arrowWidth,
        height: arrowWidth)
      pageTab.addSubview(leftArrowView)
    case .Right:
      self.init(frame: CGRect(
        x: screenWidth - tabWidth/2,
        y: (screenHeight - tabHeight)/2,
        width: tabWidth/2,
        height: tabHeight))
      pageTab.frame = CGRect(
        x: 0,
        y: 0,
        width: tabWidth,
        height: tabHeight)
      let rightArrowImage = UIImage(named: "ios7-arrow-right")
      let rightArrowView = UIImageView(image: rightArrowImage)
      rightArrowView.frame = CGRect(
        x: 0,
        y: (tabHeight - arrowWidth)/2,
        width:arrowWidth,
        height:arrowWidth
      )
      pageTab.addSubview(rightArrowView)
    }
    clipsToBounds = true
    pageTab.alpha = 0.4
    addSubview(pageTab)
  }
}
