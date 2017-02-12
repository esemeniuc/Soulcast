
import Foundation
import AWSS3

enum UploaderState: String {
  case NotReady = "Not Ready"
  case Standby = "Standby"
  case Uploading = "Uploading"
  case Failed = "Failed"
  case Finished = "Finished"
}

protocol SoulCasterDelegate: class {
  func soulDidStartUploading()
  func soulIsUploading(_ progress:Float)
  func soulDidFinishUploading(_ soul:Soul)
  func soulDidFailToUpload()
  func soulDidReachServer()
}

class SoulCaster: NSObject {
  
  var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
  var progressBlock: AWSS3TransferUtilityProgressBlock?

  var uploadProgress: Float = 0
  let fileContentTypeStr = "audio/mpeg"
  
  var outgoingSoul:Soul?
  weak var delegate:SoulCasterDelegate?
  
  var state:UploaderState = .NotReady {
    didSet {
      switch (oldValue, state) {
      case (.NotReady, .Standby):
        break
      case (.Standby, .Uploading):
        break
        
      case (.Uploading, .Finished):
        NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadingFinished"), object: nil)
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
      DispatchQueue.main.async(execute: {
        self.uploadProgress = Float(progress.fractionCompleted)
        self.delegate?.soulIsUploading(self.uploadProgress)
      })
    }
    self.completionHandler = { (task, error) -> Void in
      DispatchQueue.main.async(execute: {
        if ((error) != nil){
          assert(false, "OOPS!")
          print("Failed with Error: \(error?.localizedDescription)");
        } else if(self.uploadProgress != 1.0) {
          assert(false, "OOPS!")
          print("Error: Failed - Likely due to invalid region / filename")
        } else {
          //success.
        }
      })
    }
    state = .Standby
    //TODO: reachability
  }
  
  func validate(_ someSoul:Soul) {
    if state != .Standby {
      assert(false, "tried to upload in a bad state! \(state.rawValue)")
    }
    assert(someSoul.voice.s3Key != nil)
    assert(someSoul.voice.epoch != nil)
    assert(someSoul.longitude != nil)
    assert(someSoul.latitude != nil)
    assert(someSoul.radius != nil)
    assert(someSoul.voice.localURL != nil, "There's nothing to upload!!!")
//    assert(someSoul.token != nil)
  }
  
  fileprivate func upload(_ fileURL: URL, key:String){
    let expression = AWSS3TransferUtilityUploadExpression()
    expression.progressBlock = progressBlock
    
    //continuewithblock substitutes with completion handler...
    
    AWSS3TransferUtility.default().uploadFile(
      fileURL,
      bucket: S3BucketName,
      key: key,
      contentType: fileContentTypeStr,
      expression: expression,
      completionHander: completionHandler).continue({ (task) -> AnyObject? in
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
          self.postToServer(self.outgoingSoul!)
          //TODO: indicate success with some sick animation
        }
        return nil
        })
    
    self.delegate?.soulDidStartUploading()

  }
  
  func cast(_ localSoul:Soul) {
    validate(localSoul)
    self.outgoingSoul = localSoul
    let uploadKey = localSoul.voice.s3Key! + ".mp3"
    upload(URL(fileURLWithPath: localSoul.voice.localURL!), key: uploadKey)
    
  }
  
  fileprivate func postToServer(_ localSoul:Soul) {
    if localSoul.token == nil {
//      localSoul.token = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    }
    switch localSoul.type {
    case .Broadcast:
      ServerFacade.post(localSoul, success: {
        //success
      }) { statusCode in
        print(statusCode)
      }
    case .Improve:
      ServerFacade.improve(localSoul, success: {
        //success
      }) { statusCode in
        print(statusCode)
      }
    case .Direct:
      print("Posting direct soul to server!")
    }
  }
  
}

