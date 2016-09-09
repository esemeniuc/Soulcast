//
//  IncomingCollectionLayout.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class IncomingCollectionFlowLayout: UICollectionViewFlowLayout {
  //
  let defaultSize:CGSize = CGSize(width: screenWidth * 0.95, height: screenHeight * 0.1)
  
  override init() {
    super.init()
    setup()
  }
  
  func setup() {
    scrollDirection = .Vertical
    itemSize = defaultSize
    minimumLineSpacing = 5
    sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)!
    attributes.frame = CGRect(
      x: CGRectGetMinX(attributes.frame),
      y: CGRectGetMinY(attributes.frame),
      width: CGRectGetWidth(attributes.frame),
      height: CGRectGetHeight(attributes.frame)/10)
    attributes.alpha = 0
    return attributes
  }
  
  override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)!
    if itemIndexPath.row == 0 {
      attributes.frame = CGRect(
        x: CGRectGetMinX(attributes.frame),
        y: CGRectGetMinY(attributes.frame),
        width: CGRectGetWidth(attributes.frame),
        height: CGRectGetHeight(attributes.frame)/10)
    }
    return attributes
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}