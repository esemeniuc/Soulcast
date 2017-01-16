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
  let defaultSize:CGSize = CGSize(width: screenWidth * 0.9, height: screenHeight * 0.085)
  
  override init() {
    super.init()
    setup()
  }
  
  func setup() {
    scrollDirection = .vertical
    itemSize = defaultSize
    minimumLineSpacing = 5
    sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)!
    attributes.frame = CGRect(
      x: attributes.frame.minX,
      y: attributes.frame.minY,
      width: attributes.frame.width,
      height: attributes.frame.height/10)
    attributes.alpha = 0
    return attributes
  }
  
  override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)!
    if itemIndexPath.row == 0 {
      attributes.frame = CGRect(
        x: attributes.frame.minX,
        y: attributes.frame.minY,
        width: attributes.frame.width,
        height: attributes.frame.height/10)
    }
    return attributes
  }
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
