
import UIKit
import AVFoundation
import TheAmazingAudioEngine

let audioController = AEAudioController(audioDescription: AEAudioController.nonInterleaved16BitStereoAudioDescription(), inputEnabled: true)

enum FileReadWrite {
  case Read
  case Write
}

enum RecorderState {
  case Standby // 0
  case RecordingStarted
  case RecordingLongEnough // 2
  case Paused
  case Failed // 4
  case Finished // 5
  case Unknown // 6
  case Err
}

protocol SoulRecorderDelegate {
  func soulDidStartRecording()
  func soulDidFinishRecording(newSoul: Soul)
  func soulDidFailToRecord()
  func soulDidReachMinimumDuration()
}

class SoulRecorder: NSObject {
  let minimumRecordDuration:Int = 1
  let maximumRecordDuration:Int = 5
  var currentRecordingPath:String!
  var displayLink:CADisplayLink!
  var displayCounter:Int = 0
  var recorder:AERecorder?
  var delegate:SoulRecorderDelegate?
  //records and spits out the url
  var state: RecorderState = .Standby{
    didSet{
      switch (oldValue, state){
      case (.Standby, .RecordingStarted):
        break
      case (.RecordingStarted, .RecordingLongEnough):
        break
      case (.RecordingStarted, .Failed):
        break
      case (.RecordingLongEnough, .Failed):
        assert(false, "Should not be here!!")
      case (.RecordingLongEnough, .Finished):
        break
      case (.Failed, .Standby):
        break
      case (.Finished, .Standby):
        break
      case (let x, .Err):
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
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    
  }
  
  func displayLinkFired(link:CADisplayLink) {
    if state == .RecordingStarted || state == .RecordingLongEnough { displayCounter += 1 }
    if displayCounter == 60 * minimumRecordDuration {
      print("displayCounter == 60 * minimumRecordDuration")
      if state == .RecordingStarted { minimumDurationDidPass() }
    }
    if displayCounter == 60 * maximumRecordDuration {
      print("displayCounter == 60 * maximumRecordDuration")
      if state == .RecordingLongEnough { pleaseStopRecording() }
      displayCounter = 0
    }
  }
  
  func pleaseStartRecording() {
    print("pleaseStartRecording()")
    if SoulPlayer.playing {
      
      assert(false, "Should not be recording while audio is being played")
    }
    if state != .Standby {
      assert(false, "OOPS!! Tried to start recording from an inappropriate state!")
    } else {
      startRecording()
      state = .RecordingStarted
    }
  }
  
  func pleaseStopRecording() {
    print("pleaseStopRecording()")
    if state == .RecordingStarted {
      discardRecording()
    } else if state == .RecordingLongEnough {
      saveRecording()
    }
    displayCounter = 0
  }
  
  private func startRecording() {
    print("startRecording()")
    do {
      try audioController.start()
    } catch {
      assert(true, "audioController start error")
    }
    recorder = AERecorder(audioController: audioController)
    currentRecordingPath = outputPath()
    do {
      try recorder?.beginRecordingToFileAtPath(currentRecordingPath, fileType: AudioFileTypeID(kAudioFileM4AType))
    } catch {
      print("OOPS! at startRecording()")
    }
    audioController.addOutputReceiver(recorder)
    audioController.addInputReceiver(recorder)
    
  }
  
  private func minimumDurationDidPass() {
    print("minimumDurationDidPass()")
    state = .RecordingLongEnough
    delegate?.soulDidReachMinimumDuration()
  }
  
  private func pauseRecording() {
    //TODO:
  }
  
  private func resumeRecording() {
    //TODO:
  }
  
  func outputPath() -> String {
    var outputPath:String!
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    if paths.count > 0 {
      let randomNumberString = String(NSDate.timeIntervalSinceReferenceDate().description)
      print("randomNumberString: \(randomNumberString)")
      outputPath = paths[0] + "/Recording" + randomNumberString + ".m4a"
      let manager = NSFileManager.defaultManager()
      if manager.fileExistsAtPath(outputPath) {
        do {
          try manager.removeItemAtPath(outputPath)
        } catch {
          print("outputPath(readOrWrite:FileReadWrite)")
        }
      }
    }
    return outputPath
  }
  
  private func discardRecording() {
    print("discardRecording")
    state = .Failed
    recorder?.finishRecording()
    resetRecorder()
    delegate?.soulDidFailToRecord()
  }
  
  private func saveRecording() {
    print("saveRecording")
    state = .Finished
    recorder?.finishRecording()
    let newSoul = Soul()
    newSoul.localURL = currentRecordingPath
    delegate?.soulDidFinishRecording(newSoul)
    resetRecorder()
    
  }
  
  private func resetRecorder() {
    print("resetRecorder")
    state = .Standby
    audioController.removeOutputReceiver(recorder)
    audioController.removeInputReceiver(recorder)
    recorder = nil
    
  }
  
}
