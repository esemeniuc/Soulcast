//
//  Voice.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation

enum VoiceContext {
  case soul
  case waveCast
  case waveCall
  case waveReply
}

struct Voice {
  let epoch:Int
  var s3Key:String?
  var localURL:String?
  var context:VoiceContext? = nil
  var contextEpoch: Int = 0
  
  init(epoch: Int, s3Key: String?, localURL: String?) {
    self.epoch = epoch
    self.s3Key = s3Key
    self.localURL = localURL
  }
  
  static func from(_ hash:[String : Any]) -> Voice? {
    if let epoch = hash["epoch"] as? Int,
      let s3Key = hash["s3key"] as? String {
      return Voice(epoch: epoch,
                   s3Key: s3Key,
                   localURL: nil)
    }
    return nil
  }
  func toParams() -> [String: Any] {
    return ["s3key": s3Key!, "epoch": epoch]
  }
}
