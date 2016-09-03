
import Foundation
import AWSS3

enum UploaderState: String {
  case NotReady = "Not Ready"
  case Standby = "Standby"
  case Uploading = "Uploading"
  case Failed = "Failed"
  case Finished = "Finished"
}

protocol SoulCasterDelegate {
  func soulDidStartUploading()
  func soulIsUploading(progress:Float)
  func soulDidFinishUploading(soul:Soul)
  func soulDidFailToUpload()
  func soulDidReachServer()
}

class SoulCaster: NSObject {
  
  var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
  var progressBlock: AWSS3TransferUtilityProgressBlock?

  var uploadProgress: Float = 0
  let fileContentTypeStr = "audio/mpeg"
  
  var outgoingSoul:Soul?
  var delegate:SoulCasterDelegate?
  
  var state:UploaderState = .NotReady {
    didSet {
      switch (oldValue, state) {
      case (.NotReady, .Standby):
        break
      case (.Standby, .Uploading):
        break
        
      case (.Uploading, .Finished):
        NSNotificationCenter.defaultCenter().postNotificationName("uploadingFinished", object: nil)
        break
        
      case (.Finished, .Standby):
        break
        
      case (let x, .Failed):
        print("soulCasterState x.rawValue: \(x.rawValue)")
      case (let x, .NotReady):
        print("soulCasterState x.rawValue: \(x.rawValue)")
        break
      default:
        assert(false, "OOPS!!!")
      }
    }
  }
  
  override init() {
    super.init()
    setup()
  }
  
  func setup() {
    uploadProgress = 0
    
    self.progressBlock = {(task, progress) in
      dispatch_async(dispatch_get_main_queue(), {
        self.uploadProgress = Float(progress.fractionCompleted)
        self.delegate?.soulIsUploading(self.uploadProgress)
      })
    }
    self.completionHandler = { (task, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), {
        if ((error) != nil){
          print("Failed with Error: \(error?.localizedDescription)");
        } else if(self.uploadProgress != 1.0) {
          print("Error: Failed - Likely due to invalid region / filename")
        } else {
          //success.
        }
      })
    }
    state = .Standby
    //TODO: reachability
  }
  
  func validate(someSoul:Soul) {
    if state != .Standby {
      assert(false, "tried to upload in a bad state! \(state.rawValue)")
    }
    assert(someSoul.s3Key != nil)
    assert(someSoul.epoch != nil)
    assert(someSoul.longitude != nil)
    assert(someSoul.latitude != nil)
    assert(someSoul.radius != nil)
//    assert(someSoul.token != nil)
    assert(someSoul.localURL != nil, "There's nothing to upload!!!")
  }
  
  private func upload(fileURL: NSURL, key:String){
    let expression = AWSS3TransferUtilityUploadExpression()
    expression.progressBlock = progressBlock
    
    //continuewithblock substitutes with completion handler...
    
    AWSS3TransferUtility.defaultS3TransferUtility().uploadFile(
      fileURL,
      bucket: S3BucketName,
      key: key,
      contentType: fileContentTypeStr,
      expression: expression,
      completionHander: completionHandler).continueWithBlock { (task) -> AnyObject? in
        if let error = task.error {
          print("AWSS3TransferUtility.defaultS3TransferUtility().uploadFile error: \(error.localizedDescription)")
          //TODO: indicate failure
        }
        if let exception = task.exception {
          print("AWSS3TransferUtility.defaultS3TransferUtility().uploadFile exception: \(exception.description)")
          //TODO: indicate failure
        }
        if let _ = task.result {
          print("Upload Success!")
          self.delegate?.soulDidFinishUploading(self.outgoingSoul!)
          //TODO: indicate success with some sick animation
        }
        return nil
    }
    
    self.delegate?.soulDidStartUploading()

  }
  
  func cast(localSoul:Soul) {
    validate(localSoul)
    self.outgoingSoul = localSoul
    let uploadKey = localSoul.s3Key! + ".mp3"
    upload(NSURL(fileURLWithPath: localSoul.localURL!), key: uploadKey)
    postToServer(localSoul)
  }
  
  func postToServer(localSoul:Soul) {
    
    ServerFacade.post(localSoul, success: {
      //success
    }) { statusCode in
      print(statusCode)
    }
  }
  
}

extension SoulCaster {
  private func castSoulToServer(outgoingSoul:Soul) {
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
