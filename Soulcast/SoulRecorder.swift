
import UIKit
import AVFoundation
import TheAmazingAudioEngine

let audioController = AEAudioController(audioDescription: AEAudioController.nonInterleaved16BitStereoAudioDescription(), inputEnabled: true)

enum FileReadWrite {
  case read
  case write
}

enum RecorderState {
  case standby // 0
  case recordingStarted
  case recordingLongEnough // 2
  case paused
  case failed // 4
  case finished // 5
  case unknown // 6
  case err
}

protocol SoulRecorderDelegate: class {
  func soulDidStartRecording()
  func soulIsRecording(_ progress:CGFloat)
  func recorderDidFinishRecording(_ localURL: String)
  func soulDidFailToRecord()
  func soulDidReachMinimumDuration()
}

class SoulRecorder: NSObject {
  let minimumRecordDuration:Int = 1
  var maximumRecordDuration:Int = 5
  var currentRecordingPath:String!
  var displayLink:CADisplayLink!
  var displayCounter:Int = 0
  var recorder:AERecorder?
  weak var delegate:SoulRecorderDelegate?
  //records and spits out the url
  var state: RecorderState = .standby{
    didSet{
      switch (oldValue, state){
      case (.standby, .recordingStarted):
        break
      case (.recordingStarted, .recordingLongEnough):
        break
      case (.recordingStarted, .failed):
        break
      case (.recordingLongEnough, .failed):
        assert(false, "Should not be here!!")
      case (.recordingLongEnough, .finished):
        break
      case (.failed, .standby):
        break
      case (.finished, .standby):
        break
      case (let x, .err):
        print("state x.hashValue: \(x.hashValue)")
      default:
        print("oldValue: \(oldValue.hashValue), state: \(state.hashValue)")
        assert(false, "OOPS!!!")
      }
    }
  }
  override init() {
    super.init()
    setup()
  }
  func setup() {
    displayLink = CADisplayLink(target: self, selector: #selector(SoulRecorder.displayLinkFired(_:)))
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    do {
      try audioController?.start()
    } catch {
      print("audioController.start() fail!")
    }
  }
  
  func displayLinkFired(_ link:CADisplayLink) {
    if state == .recordingStarted || state == .recordingLongEnough { displayCounter += 1 }
    if displayCounter == 60 * minimumRecordDuration {
      print("displayCounter == 60 * minimumRecordDuration")
      if state == .recordingStarted { minimumDurationDidPass() }
    }
    if displayCounter == 60 * maximumRecordDuration {
      print("displayCounter == 60 * maximumRecordDuration")
      if state == .recordingLongEnough { pleaseStopRecording() }
      displayCounter = 0
    }
    if state == .recordingStarted || state == .recordingLongEnough {
        let currentRecordDuration = CGFloat(displayCounter) / 60
        let progress:CGFloat = currentRecordDuration/CGFloat(maximumRecordDuration)
        self.delegate?.soulIsRecording(progress)
    }
  }
  
  func pleaseStartRecording() {
    print("pleaseStartRecording()")
    if SoulPlayer.playing {
      
      assert(false, "Should not be recording while audio is being played")
    }
    if state != .standby {
      assert(false, "OOPS!! Tried to start recording from an inappropriate state!")
    } else {
      startRecording()
      state = .recordingStarted
    }
  }
  
  func pleaseStopRecording() {
    print("pleaseStopRecording()")
    if state == .recordingStarted {
      discardRecording()
    } else if state == .recordingLongEnough {
      saveRecording()
    }
    displayCounter = 0
  }
  
  fileprivate func startRecording() {
    print("startRecording()")
    do {
      try audioController?.start()
    } catch {
      assert(true, "audioController start error")
    }
    recorder = AERecorder(audioController: audioController)
    currentRecordingPath = outputPath()
    do {
      try recorder?.beginRecordingToFile(atPath: currentRecordingPath, fileType: AudioFileTypeID(kAudioFileM4AType))
        delegate?.soulDidStartRecording()
    } catch {
      print("OOPS! at startRecording()")
    }
    audioController?.addOutputReceiver(recorder)
    audioController?.addInputReceiver(recorder)
    
  }
  
  fileprivate func minimumDurationDidPass() {
    print("minimumDurationDidPass()")
    state = .recordingLongEnough
    delegate?.soulDidReachMinimumDuration()
  }
  
  fileprivate func pauseRecording() {
    //TODO:
  }
  
  fileprivate func resumeRecording() {
    //TODO:
  }
  
  func outputPath() -> String {
    var outputPath:String!
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    if paths.count > 0 {
      let randomNumberString = String(Date.timeIntervalSinceReferenceDate.description)
      print("randomNumberString: \(randomNumberString!)")
      outputPath = paths[0] + "/Recording" + randomNumberString! + ".m4a"
      let manager = FileManager.default
      if manager.fileExists(atPath: outputPath) {
        do {
          try manager.removeItem(atPath: outputPath)
        } catch {
          print("outputPath(readOrWrite:FileReadWrite)")
        }
      }
    }
    return outputPath
  }
  
  fileprivate func discardRecording() {
    print("discardRecording")
    state = .failed
    recorder?.finishRecording()
    resetRecorder()
    delegate?.soulDidFailToRecord()
  }
  
  fileprivate func saveRecording() {
    print("saveRecording")
    state = .finished
    recorder?.finishRecording()
    delegate?.recorderDidFinishRecording(currentRecordingPath)
    resetRecorder()    
  }
  
  fileprivate func resetRecorder() {
    print("resetRecorder")
    state = .standby
    audioController?.removeOutputReceiver(recorder)
    audioController?.removeInputReceiver(recorder)
    recorder = nil
    
  }
  
  static func askForMicrophonePermission(_ success:@escaping ()->(), failure:@escaping ()->()) {
    //TODO:
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
      if granted {
        success()
      } else {
        failure()
      }
    }
  }
  
}
