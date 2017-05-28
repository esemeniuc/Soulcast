//
//  VoiceFetcher.swift
//  Soulcast
//
//  Created by June Kim on 2017-03-26.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import AWSS3

protocol VoiceFetcherDelegate: class {
  func voiceDidFinishDownloading(_ fetcher:VoiceFetcher, voice:Voice)
  func voiceDidFailToDownload(_ fetcher:VoiceFetcher)
}

class VoiceFetcher: NSObject{
  var fetchingVoice: Voice
  weak var delegate: VoiceFetcherDelegate?
  var progress: Float = 0
  static let cache = Cache<String>(
    name: "Voice",
    config: Config(
      frontKind: .memory,
      backKind: .disk,
      expiry: .date(Date().addingTimeInterval(1000000)),
      maxSize: 100000,
      maxObjects: 10000))
  var trialCounter = 0
  let MAX_TRIAL = 15
  var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
  var waveEpoch = 0
  
  init(voice:Voice) {
    fetchingVoice = voice
    super.init()
    fetch(fetchingVoice)
  }
  
  fileprivate func fetch(_ incomingVoice:Voice) {
    let key = incomingVoice.s3Key!
    VoiceFetcher.cache.object(key) { (localURL: String?) in
      guard localURL != nil else {
        self.startDownloading(incomingVoice)
        return
      }
      //check if file exists
      let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
      let tempPath = paths.first
      let filePath = tempPath! + "/" + key
      if FileManager.default.fileExists(atPath: filePath) {
        var localVoice = incomingVoice
        localVoice.localURL = filePath
        self.delegate?.voiceDidFinishDownloading(self, voice: localVoice)
      } else {
        self.startDownloading(incomingVoice)
      }
    }
  }
  
  
  fileprivate func tryAgain(_ voice: Voice) {
    print("Trying to download a voice again!!")
    let delayTime = DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.startDownloading(voice)
    }
  }
  
  fileprivate func startDownloading(_ incomingVoice:Voice) {
    var s3Key = incomingVoice.s3Key! as String
    trialCounter += 1
    let expression = AWSS3TransferUtilityDownloadExpression()
    expression.progressBlock = {(task, progress) in
      DispatchQueue.main.async(execute: {
        self.progress = Float(progress.fractionCompleted)
      })
    }
    self.completionHandler = { (task, location, data, error) -> Void in
      DispatchQueue.main.async(execute: {
        if (error != nil){
          if self.trialCounter < self.MAX_TRIAL {
            self.tryAgain(incomingVoice)
          } else {
            print("startDownloading FAIL! error:\(error!)")
            self.delegate?.voiceDidFailToDownload(self)
          }
        } else if( self.progress != 1.0 ) {
          if self.trialCounter < self.MAX_TRIAL {
            self.tryAgain(incomingVoice)
          } else {
            self.delegate?.voiceDidFailToDownload(self)
          }
        } else{
          self.trialCounter = 0
          let key = incomingVoice.s3Key!
          let filePath = self.saveToCache(data!, key:key)
          var caughtVoice = incomingVoice
          caughtVoice.localURL = filePath
          VoiceFetcher.cache.add(key, object: filePath)
          self.delegate?.voiceDidFinishDownloading(self, voice: caughtVoice)
          
        }
      })
    }
    
    let transferUtility = AWSS3TransferUtility.default()
    
    transferUtility.downloadData(
      fromBucket: S3BucketName,
      key: s3Key,
      expression: expression,
      completionHandler: completionHandler)
  }
  
  
  func saveToCache(_ data: Data, key:String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let tempPath = paths.first
    let filePath = tempPath! + "/" + key
    do {
      if FileManager.default.fileExists(atPath: filePath) {
        try FileManager.default.removeItem(atPath: filePath)
      }
      try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
      
    } catch {
      print("movedFileToDocuments error!")
    }
    return filePath
  }
  
  
}
