//
//  Voice.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

struct Voice {
  let epoch:Int
  var s3Key:String?
  var localURL:String?
  
  func append(key:String) -> Voice {
    return Voice(epoch: epoch, s3Key: key, localURL: localURL)
  }
  
  func append(url:String) -> Voice {
    return Voice(epoch: epoch, s3Key: s3Key, localURL: url)
  }
  
}
