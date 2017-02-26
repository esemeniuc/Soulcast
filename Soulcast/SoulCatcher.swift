//
//  SoulCatcher.swift
//  SoulCast
//
//  Created by Camvy Films on 2015-03-13.
//  Copyright (c) 2015 June. All rights reserved.
//
import Foundation
import UIKit
import AWSS3

protocol SoulCatcherDelegate: class {
  func soulDidStartToDownload(_ catcher:SoulCatcher, soul:Soul)
  func soulIsDownloading(_ catcher:SoulCatcher, progress:Float)
  func soulDidFinishDownloading(_ catcher:SoulCatcher, soul:Soul)
  func soulDidFailToDownload(_ catcher:SoulCatcher)
}

//downloads a soul and puts it in a queue
class SoulCatcher: NSObject {
  
  var catchingSoul: Soul
  weak var delegate: SoulCatcherDelegate?
  var progress: Float = 0
  static let soulCaughtNotification = "soulCaughtNotification"
  
  var trialCounter = 0
  let MAX_TRIAL = 15
  
  var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?

  init(soul:Soul) {
    catchingSoul = soul
    super.init()
    catchSoulObject(catchingSoul)
  }
  init(soulHash:[String : AnyObject]) {
    catchingSoul = Soul.fromAPNSHash(soulHash as NSDictionary)
    super.init()
    catchSoulObject(catchingSoul)
  }
  
  fileprivate func catchSoul(_ soulInfo:[String : AnyObject]) {
    catchSoulObject(Soul.fromAPNSHash(soulInfo as NSDictionary))
  }
  
  fileprivate func catchSoulObject(_ incomingSoul:Soul) {
    startDownloading(incomingSoul)
  }
  
  func rootVC() -> UIViewController {
    return (UIApplication.shared.keyWindow?.rootViewController)!
  }
  
  fileprivate func tryAgain(_ soul: Soul) {
    print("Trying to download a soul again!!")
    let delayTime = DispatchTime.now() + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.startDownloading(soul)
    }
  }
  
  fileprivate func startDownloading(_ incomingSoul:Soul) {
    let s3Key = incomingSoul.voice.s3Key! as String + ".mp3"
    trialCounter += 1
    let expression = AWSS3TransferUtilityDownloadExpression()
    expression.progressBlock = {(task, progress) in
      DispatchQueue.main.async(execute: {
        self.progress = Float(progress.fractionCompleted)
        self.delegate?.soulIsDownloading(self, progress: self.progress)
      })
    }
    
    self.completionHandler = { (task, location, data, error) -> Void in
      DispatchQueue.main.async(execute: {
        if ((error) != nil){
          if self.trialCounter < self.MAX_TRIAL {
            self.tryAgain(incomingSoul)
          } else {
            print("startDownloading FAIL! error:\(error!)")
            self.delegate?.soulDidFailToDownload(self)
          }
        } else if(self.progress != 1.0) {
          if self.trialCounter < self.MAX_TRIAL {
            self.tryAgain(incomingSoul)
          } else {
            self.delegate?.soulDidFailToDownload(self)
          }
        } else{
          self.trialCounter = 0
          let filePath = self.saveToCache(data!, key:incomingSoul.voice.s3Key!)
          incomingSoul.voice.localURL = filePath
          self.delegate?.soulDidFinishDownloading(self, soul: incomingSoul)
          
        }
      })
    }
    
    let transferUtility = AWSS3TransferUtility.default()

    transferUtility.downloadData(
      fromBucket: S3BucketName,
      key: s3Key,
      expression: expression,
      completionHandler: completionHandler)
    //optional: .continuewithblock...
    
  }
  
  
  
  func saveToCache(_ data: Data, key:String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let tempPath = paths.first
    let filePath = tempPath! + "/" + key + ".m4a"
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
  
  static func fetchLatest(_ completion:@escaping (Soul?)->()){
    ServerFacade.getLatest({ (successJSON) in
      //TODO: objectify successJSON, download the thing, and run completion
      
      completion(MockFactory.mockSoulOne())
      }) { (statuscode) in
        print(statuscode)
    }
  }
}


  

