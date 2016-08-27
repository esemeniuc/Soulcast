//
//  SoulCatcher.swift
//  SoulCast
//
//  Created by Camvy Films on 2015-03-13.
//  Copyright (c) 2015 June. All rights reserved.
//
import Foundation
import UIKit

protocol SoulCatcherDelegate {
  func soulDidStartToDownload(soul:Soul)
  func soulIsDownloading(progress:Float)
  func soulDidFinishDownloading(soul:Soul)
  func soulDidFailToDownload()
}

let soulCatcher = SoulCatcher()

class SoulCatcher: NSObject {
  
  var session: NSURLSession?
  var downloadTask: NSURLSessionDownloadTask?
  var catchingSoul: Soul?
  var catchingSouls: [Soul] = []
  var delegate: SoulCatcherDelegate?
  
  var token: dispatch_once_t = 0
  
  func setup() {
    dispatch_once(&token) {
//      let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(BackgroundSessionDownloadIdentifier)
//      self.session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
  }
  
  func catchSoul(userInfo:NSDictionary) {
    if let apsHash: NSDictionary = userInfo["aps"] as? NSDictionary {
      if apsHash["type"] as? String == "incoming" {
        print("Catching an incoming aps soul!")
//        catchSoul(soulFromApsHash(apsHash))
        
      } else if apsHash["type"] as? String == "direct" {
        print("Catching a directed aps soul!")
        //TODO:
//        catchSoul(soulFromApsHash(apsHash))
      } else {
        assert(false, "Trying to catch a non-incoming soul!")
      }
    
    }
    //Get a reference to incoming VC, pass soul to incomingVC.
  }
  
  func catchSoulObject(incomingSoul:Soul) {
    setup()
    catchingSouls.append(incomingSoul)
//    startDownloadingAudioFrom(incomingSoul: incomingSoul)
  }
  
  func playAudioFrom(incomingSoul:Soul) {
//    soulPlayer.startPlaying(incomingSoul)
  }
  
  private func soulFromApsHash (apsHash:NSDictionary) -> Soul {
    let soulHash = apsHash["soul"] as! NSDictionary
    let incomingSoul = Soul()
    let incomingDevice = Device()
    incomingDevice.id = soulHash["device_id"] as? Int
//    incomingSoul.device = incomingDevice
    incomingSoul.epoch = soulHash["epoch"] as? Int
    incomingSoul.latitude = (soulHash["latitude"] as? NSString)?.doubleValue
    incomingSoul.longitude = (soulHash["longitude"] as? NSString)?.doubleValue
    incomingSoul.radius = (soulHash["radius"] as? NSString)?.doubleValue
    incomingSoul.s3Key = soulHash["s3Key"] as? String
    return incomingSoul
  }
}


extension SoulCatcher: NSURLSessionDownloadDelegate {
  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    if let catcherDelegate = self.delegate {
      dispatch_async(dispatch_get_main_queue()) {
        catcherDelegate.soulIsDownloading(progress)
      }
    }
  }

  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    
    var finishedSoul:Soul!
    for eachSoul in catchingSouls {
      if downloadTask.taskDescription == eachSoul.s3Key! {
        finishedSoul = eachSoul
        break
      }
    }
    
    let filePath = movedFileToDocuments(location, withKey:finishedSoul.s3Key!)
    finishedSoul.localURL = filePath
    if let catcherDelegate = self.delegate {
      dispatch_async(dispatch_get_main_queue()) {
        catcherDelegate.soulDidFinishDownloading(finishedSoul)
        
      }
    }
    
    //TODO: notify that this soul is finished downloading
    //self.playAudioFrom(self.catchingSoul!)
  }
  
  func movedFileToDocuments(location:NSURL, withKey:String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsPath = paths.first
    let filePath = documentsPath! + "/" + withKey + ".m4a"
    do {
      if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
        try NSFileManager.defaultManager().removeItemAtPath(filePath)
      }
      try NSFileManager.defaultManager().moveItemAtURL(location, toURL: NSURL.fileURLWithPath(filePath))
      
    } catch {
      print("movedFileToDocuments error!")
    }
    
    //TODO: incoming soul path is invalid?
    return filePath
  }
  
}

extension SoulCatcher: NSURLSessionDelegate {
  func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    assert(error == nil, "NSURLSessionTask error!! \(error?.localizedDescription)")
    if let catcherDelegate = self.delegate{
      dispatch_async(dispatch_get_main_queue()) {
        catcherDelegate.soulDidFailToDownload()
      }
    }
    self.downloadTask = nil
  }
}



