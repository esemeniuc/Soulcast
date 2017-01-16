//
//  Randomizer.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-26.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

class Randomizer {
  static func randomString(withLength length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString : String = ""
    let len = UInt32(letters.length)
    for _ in 0...len {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
  }
}
