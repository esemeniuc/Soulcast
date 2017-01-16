//
//  HistoryButton.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class HistoryButton: UIButton {
  //TODO:
  override init(frame: CGRect) {
    //top right...
    let inset:CGFloat = 30
    
    super.init(frame: CGRect(x: 0, y: 0, width: 100, height:100))
    backgroundColor = .clear
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
