//
//  SoulCaster.swift
//  SoulCast
//
//  Created by Camvy Films on 2015-03-13.
//  Copyright (c) 2015 June. All rights reserved.
//
import Foundation
import AWSS3

enum UploaderState {
  case NotReady
  case Standby
  case Uploading
  case Failed
  case Finished
}

protocol SoulCasterDelegate {
  func soulDidStartUploading()
  func soulIsUploading(progress:Float)
  func soulDidFinishUploading()
  func soulDidFailToUpload()
  func soulDidReachServer()
}

var singleSoulCaster:SoulCaster = SoulCaster()

class SoulCaster: NSObject {
  
  var session: NSURLSession?
  var uploadTask: NSURLSessionUploadTask?
  var uploadFileURL: NSURL?
  var uploadProgress: Float = 0
  let fileContentTypeStr = "audio/mpeg"
  
  var outgoingSoul:Soul?
  var delegate:SoulCasterDelegate?
  
  var state:UploaderState = .NotReady {
    didSet {
      switch (oldValue, state) {
      case (.Standby, .Uploading):
        break
        
      case (.Uploading, .Finished):
        NSNotificationCenter.defaultCenter().postNotificationName("uploadingFinished", object: nil)
        break
        
      case (.Finished, .Standby):
        break
        
      case (let x, .Failed):
        print("soulCasterState x.hashValue: \(x.hashValue)")
      case (let x, .NotReady):
        print("soulCasterState x.hashValue: \(x.hashValue)")
        break
      default:
        assert(false, "OOPS!!!")
      }
    }
  }
  
  override init() {
    super.init()
    setup()
//    let reachability = Reachability(hostName: serverURL)
//    if reachability.isReachable() {
//      self.state = .Standby
//      setup()
//    } else {
//      state = .NotReady
//    }
//    reachability.reachableBlock = { (reachBlock:Reachability!) in
//      self.state = .Standby
//      self.setup()
//    }
//    reachability.unreachableBlock = { (reachBlock:Reachability!) in
//      self.state = .NotReady
//    }
//    reachability.startNotifier()
  }
  
  func setup() {
    var token: dispatch_once_t = 0
    dispatch_once(&token) {
      let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(BackgroundSessionUploadIdentifier)
      self.session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    uploadProgress = 0
  }
  
  func upload(localSoul:Soul) {
//    if state != .Standby {
//      assert(false, "tried to upload in a bad state! \(state.hashValue)")
//    }
    self.outgoingSoul = localSoul
    assert(localSoul.localURL != nil, "There's nothing to upload!!!")
    self.uploadFileURL = NSURL(fileURLWithPath: localSoul.localURL!)
    print("upload localSoul: \(localSoul) self.uploadFileURL: \(self.uploadFileURL)")
    assert(localSoul.epoch != nil, "There's no key assigned to the soul!!!")
    if (self.uploadTask != nil) {
      return;
    }
    //
    let uploadKey = localSoul.s3Key! + ".mp3"
    let presignedURLRequest = getPreSignedURLRequest(uploadKey)
    AWSS3PreSignedURLBuilder.defaultS3PreSignedURLBuilder().getPreSignedURL(presignedURLRequest) .continueWithBlock { (task:AWSTask!) -> (AnyObject!) in
      
      if (task.error != nil) {
        print("Error: %@", task.error)
      } else {
        
        let presignedURL = task.result as! NSURL!
        if (presignedURL != nil) {
          let request = NSMutableURLRequest(URL: presignedURL)
          request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
          request.HTTPMethod = "PUT"
          
          //contentType in the URLRequest must be the same as the one in getPresignedURLRequest
          request.setValue(self.fileContentTypeStr, forHTTPHeaderField: "Content-Type")
          
          self.uploadTask = self.session?.uploadTaskWithRequest(request, fromFile: self.uploadFileURL!)
          self.uploadTask?.resume()
          //self.state = .Uploading
          self.delegate?.soulDidStartUploading()
        }
      }
      return nil;
      
    }
    
    
  }
  
  func getPreSignedURLRequest(keyName: String) -> AWSS3GetPreSignedURLRequest {
    let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
    getPreSignedURLRequest.bucket = S3BucketName
    getPreSignedURLRequest.key = keyName
    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethod.PUT
    getPreSignedURLRequest.expires = NSDate(timeIntervalSinceNow: 3600)
    getPreSignedURLRequest.contentType = fileContentTypeStr
    
    return getPreSignedURLRequest
  }
  
  func notifyDelegate() {
    
  }
  
  func reset() {
    
  }
  
}

extension SoulCaster: NSURLSessionDataDelegate {
  func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    self.uploadProgress = progress
    if let tempDelegate = self.delegate {
      dispatch_async(dispatch_get_main_queue()) {
        tempDelegate.soulIsUploading(progress)
      }
    }
    
  }
}

extension SoulCaster: NSURLSessionTaskDelegate {
  func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    //finished
    if let tempDelegate = self.delegate {
      if (error == nil) {
        //self.state = .Finished
        dispatch_async(dispatch_get_main_queue()) {
          tempDelegate.soulDidFinishUploading()
          //self.state = .Standby
        }
        //castSoulToServer(outgoingSoul!)
      } else {
        //self.state = .Failed
        dispatch_async(dispatch_get_main_queue()) {
          tempDelegate.soulDidFailToUpload()
          //self.state = .Standby
        }
      }
    }
    
    self.uploadTask = nil
    
  }
}

extension SoulCaster: NSURLSessionDelegate {
  func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //TODO:
//    if ((appDelegate.backgroundUploadSessionCompletionHandler) != nil) {
//      let completionHandler:() = appDelegate.backgroundUploadSessionCompletionHandler!;
//      appDelegate.backgroundUploadSessionCompletionHandler = nil
//      completionHandler
//    }
    
    
    print("URLSessionDidFinishEventsForBackgroundURLSession Completion Handler has been invoked, background upload task has finished.")
  }
}

extension SoulCaster {
  func castSoulToServer(outgoingSoul:Soul) {
    //TODO:
    
  }
  
  /*
  Prefix Verb         URI Pattern                   Controller#Action
  api_souls GET       /api/souls(.:format)          api/souls#index
  POST                /api/souls(.:format)          api/souls#create
  new_api_soul GET    /api/souls/new(.:format)      api/souls#new
  edit_api_soul GET   /api/souls/:id/edit(.:format) api/souls#edit
  api_soul GET        /api/souls/:id(.:format)      api/souls#show
  PATCH               /api/souls/:id(.:format)      api/souls#update
  PUT                 /api/souls/:id(.:format)      api/souls#update
  DELETE              /api/souls/:id(.:format)      api/souls#destroy
*/
  
}
