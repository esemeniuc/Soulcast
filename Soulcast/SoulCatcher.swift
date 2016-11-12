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

protocol SoulCatcherDelegate {
  func soulDidStartToDownload(catcher:SoulCatcher, soul:Soul)
  func soulIsDownloading(catcher:SoulCatcher, progress:Float)
  func soulDidFinishDownloading(catcher:SoulCatcher, soul:Soul)
  func soulDidFailToDownload(catcher:SoulCatcher)
}

//downloads a soul and puts it in a queue
class SoulCatcher: NSObject {
  
  var catchingSoul: Soul?
  var delegate: SoulCatcherDelegate?
  var progress: Float = 0
  static let soulCaughtNotification = "soulCaughtNotification"
  
  var trialCounter = 0
  let MAX_TRIAL = 10
  
  var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?

  func setup() {

  }
  
  func catchSoul(soulInfo:[String : AnyObject]) {
    catchSoulObject(Soul.fromAPNSHash(soulInfo))
  }
  
  func catchSoulObject(incomingSoul:Soul) {
    startDownloading(incomingSoul)
  }
  
  func rootVC() -> UIViewController {
    return (UIApplication.sharedApplication().keyWindow?.rootViewController)!
  }
  
  private func tryAgain(soul: Soul) {
    print("Trying to download a soul again!!")
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.15 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.startDownloading(soul)
    }
  }
  
  private func startDownloading(incomingSoul:Soul) {
    let s3Key = incomingSoul.s3Key! as String + ".mp3"
    trialCounter += 1
    let expression = AWSS3TransferUtilityDownloadExpression()
    expression.progressBlock = {(task, progress) in
      dispatch_async(dispatch_get_main_queue(), {
        self.progress = Float(progress.fractionCompleted)
        self.delegate?.soulIsDownloading(self, progress: self.progress)
      })
    }
    
    self.completionHandler = { (task, location, data, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
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
          let filePath = self.saveToCache(data!, key:incomingSoul.s3Key!)
          incomingSoul.localURL = filePath
          self.delegate?.soulDidFinishDownloading(self, soul: incomingSoul)
          
        }
      })
    }
    
    let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()

    transferUtility.downloadDataFromBucket(
      S3BucketName,
      key: s3Key,
      expression: expression,
      completionHander: completionHandler)
    //optional: .continuewithblock...
    
  }
  
  
  
  func saveToCache(data: NSData, key:String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let tempPath = paths.first
    let filePath = tempPath! + "/" + key + ".m4a"
    do {
      if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
        try NSFileManager.defaultManager().removeItemAtPath(filePath)
      }
      data.writeToFile(filePath, atomically: true)
      
    } catch {
      print("movedFileToDocuments error!")
    }
    return filePath
  }
  
  static func fetchLatest(completion:(Soul?)->()){
    ServerFacade.getLatest({ (successJSON) in
      //TODO: objectify successJSON, download the thing, and run completion
      
      completion(MockFactory.mockSoulOne())
      }) { (statuscode) in
        print(statuscode)
    }
  }
}


  

