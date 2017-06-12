
import Foundation
import AudioKit

enum RecorderState {
  case standby
  case recordingStarted
  case recordingLongEnough
  case failed
  case finished
  case unknown
  case err
}

protocol RecorderSubscriber: class {
  func recorderStarted()
  func recorderReachedMinDuration()
  func recorderRecording(_ progress:CGFloat)
  func recorderFinished(_ localURL: URL)
  func recorderFailed()
  var hashValue: Int { get }
}

class Recorder {
  static var minDuration:Int = 1
  static var maxDuration:Int = 5 {
    didSet { assert(maxDuration > minDuration) }
  }
  static var state: RecorderState = .standby{
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
  fileprivate static var subscribers: [RecorderSubscriber] = []
  fileprivate static var nodeRecorder: AKNodeRecorder!
  fileprivate static var timer: Timer!
  fileprivate static var frameCounter: Int = 0
  
  static func startRecording(subscriber: RecorderSubscriber) {
    subscribe(subscriber)
    guard gotPermission() else {
      getPermission() { granted in
        if granted { startRecording(subscriber: subscriber) }
      }
      return
    }
    startTimer()
    state = .recordingStarted
    _ = subscribers.map{$0.recorderStarted()}
    setSession()
    let mic = AKMicrophone()
    let micMixer = AKMixer(mic)
    mic.start()
    AudioKit.output = micMixer
    micMixer.volume = 0
    do {
      nodeRecorder = try AKNodeRecorder(node: mic)
      AudioKit.start()
      try nodeRecorder.record()
    } catch {
      state = .err
      _ = subscribers.map{$0.recorderFailed()}
    }
  }
  
  fileprivate static func startTimer() {
    DispatchQueue.main.async {
      if #available(iOS 10.0, *) {
        timer = Timer.scheduledTimer(
          withTimeInterval: 0.01667,
          repeats: true,
          block: { timer in
            timerFired()
        })
      } else {
        // Fallback on earlier versions
      }
    }
  }
  fileprivate static func timerFired() {
    if state == .recordingStarted || state == .recordingLongEnough { frameCounter += 1 }
    if frameCounter == 60 * minDuration {
      if state == .recordingStarted {
        _ = subscribers.map{$0.recorderReachedMinDuration()}
        state = .recordingLongEnough
      }
    }
    if frameCounter == 60 * maxDuration {
      if state == .recordingLongEnough { requestStopRecording() }
      frameCounter = 0
    }
    if state == .recordingStarted || state == .recordingLongEnough {
      let currentRecordDuration = CGFloat(frameCounter) / 60
      let progress:CGFloat = currentRecordDuration/CGFloat(maxDuration)
      _ = subscribers.map{$0.recorderRecording(progress)}
    }
  }

  static func requestStopRecording(subscriber: RecorderSubscriber? = nil) {
    if state == .recordingStarted {
      discardRecording()
    } else if state == .recordingLongEnough {
      saveRecording()
    }
    timer.invalidate()
    frameCounter = 0
    if let sub = subscriber {unsubscribe(sub)}
  }
  
  fileprivate static func discardRecording() {
    state = .failed
    nodeRecorder.stop()
    AudioKit.stop()
    _ = subscribers.map{$0.recorderFailed()}
    state = .standby
  }
  
  fileprivate static func saveRecording() {
    state = .finished
    nodeRecorder.stop()
    AudioKit.stop()
    if let url = nodeRecorder.audioFile?.avAsset.url {
      _ = subscribers.map{$0.recorderFinished(url)}
    }
    state = .standby
  }
  
  fileprivate static func setSession() {
    AKAudioFile.cleanTempDirectory()
    AKSettings.enableLogging = false
    AKSettings.bufferLength = .medium
    do {
      if #available(iOS 10.0, *) {
        try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
      } else {
        // Fallback on earlier versions
      }
    } catch { AKLog("Could not set session category.") }
    AKSettings.defaultToSpeaker = true
  }
  
  static func gotPermission() -> Bool {
    return AVAudioSession.sharedInstance().recordPermission() == .granted
  }
  
  static func getPermission(_ completion: @escaping (Bool)->()) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
      completion(granted)
      if !granted {
        //TODO: alert user...
        print("Permission to record not granted")
      }
    }
  }
  
  fileprivate static func subscribe(_ subber: RecorderSubscriber) {
    if !subscribers.contains{$0.hashValue == subber.hashValue} {
      subscribers.append(subber)
    }
  }
  
  fileprivate static func unsubscribe(_ subber: RecorderSubscriber) {
    if let index = subscribers.index(where:{$0.hashValue == subber.hashValue}) {
      subscribers.remove(at: index)
    }
  }
}








