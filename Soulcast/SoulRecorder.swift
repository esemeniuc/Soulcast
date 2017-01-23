
import Foundation
import UIKit
import AudioKit

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
  func soulDidFinishRecording(_ newSoul: Soul)
  func soulDidFailToRecord()
  func soulDidReachMinimumDuration()
}

class SoulRecorder: NSObject {
  let minimumRecordDuration:Int = 1
  var maximumRecordDuration:Int = 5
  var currentRecordingPath:String!
  var displayLink:CADisplayLink!
  var displayCounter:Int = 0
  
  var recorder: AKNodeRecorder?
  var player: AKAudioPlayer?
  let mic = AKMicrophone()
  
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
//
    AKAudioFile.cleanTempDirectory()
    AKSettings.bufferLength = .medium
    
    do {
      try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
    } catch { print("Errored setting category.") }
    
    recorder = try? AKNodeRecorder(node: mic)
    player = try? AKAudioPlayer(file: (recorder?.audioFile)!)
    
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
  
  fileprivate func minimumDurationDidPass() {
    print("minimumDurationDidPass()")
    state = .recordingLongEnough
    delegate?.soulDidReachMinimumDuration()
  }
  
  
  func pleaseStartRecording() {
    guard !SoulPlayer.playing &&
      state == .standby else {
        assert(false, "Should not be recording while audio is being played")
        assert(false, "OOPS!! Tried to start recording from an inappropriate state!")
        return
    }
    print("pleaseStartRecording()")
    
    startRecording()
    state = .recordingStarted
    displayLink.isPaused = false
  }
  
  func pleaseStopRecording() {
    print("pleaseStopRecording()")
    if state == .recordingStarted {
      discardRecording()
    } else if state == .recordingLongEnough {
      saveRecording()
    }
    resetRecorder()
    displayCounter = 0
    displayLink.isPaused = true
    AudioKit.stop()
    
  }
  
  
  fileprivate func startRecording() {
    AudioKit.start()
    do {
      try recorder?.record()
      delegate?.soulDidStartRecording()
    } catch {
      assert(true, "audioController start error")
    }
  }
  
  fileprivate func discardRecording() {
    print("discardRecording")
    state = .failed
    recorder?.stop()
    delegate?.soulDidFailToRecord()
  }
  
  fileprivate func saveRecording() {
    recorder?.stop()
    let recordedDuration = player != nil ? recorder?.audioFile?.duration  : 0
    if recordedDuration! > 0.0 {
      let url = player!.audioFile.directoryPath.absoluteString + player!.audioFile.fileNamePlusExtension
      let newSoul = Soul()
      newSoul.localURL = url
      self.delegate?.soulDidFinishRecording(newSoul)
      state = .finished
    } else {
      self.delegate?.soulDidFailToRecord()
      state = .failed
    }
    
  }
  
  fileprivate func resetRecorder() {
    do  { try recorder?.reset() } catch { print("reset recorder fail! ") }
    recorder = try? AKNodeRecorder(node: mic)
    player = try? AKAudioPlayer(file: (recorder?.audioFile)!)
    
    state = .standby
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
