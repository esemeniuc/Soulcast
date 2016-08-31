

import UIKit


class RecordingVC: UIViewController {
  
  var outgoingSoul:Soul?
  var recordingStartTime:NSDate!
  var soulRecorder = SoulRecorder()
  let soulPlayer = SoulPlayer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureAudio()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  func configureAudio() {
    soulRecorder.delegate = self
    soulRecorder.setup()
    do {
      try audioController.start()
    } catch {
      assert(false);
      print("audioController.start() error")
    }
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordingVC.soulDidFailToPlay(_:)), name: "soulDidFailToPlay", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecordingVC.soulDidFinishPlaying(_:)), name: "soulDidFinishPlaying", object: nil)
  }
  
  
  func requestStartRecording() {
    recordingStartTime = NSDate()
    soulRecorder.pleaseStartRecording()
    
  }
  
  func requestFinishRecording() {
    soulRecorder.pleaseStopRecording()
    
  }
  
  func playbackSoul(localSoul:Soul) {
    print("playbackSoul localSoul:\(localSoul)")
    soulPlayer.startPlaying(localSoul)
  }
  
  
}

extension RecordingVC: SoulRecorderDelegate {
  func soulDidStartRecording() {
    print("soulDidStartRecording")
  }
  
  func soulDidFailToRecord() {
    print("soulDidFailToRecord")
  }
  
  func soulDidReachMinimumDuration() {
    print("soulDidReachMinimumDuration")
  }
  
  func soulDidFinishRecording(newSoul: Soul) {
    print("soulDidFinishRecording")
    playbackSoul(newSoul)
    //TODO: mock and semi-real sending here...
    newSoul.printProperties()
    
    
  }
}

extension RecordingVC {
  func soulDidFailToPlay(notification:NSNotification) {
    let failSoul = notification.object as! Soul
    print(failSoul.description)
  }
  
  func soulDidFinishPlaying(notification:NSNotification) {
    let finishedSoul = notification.object as! Soul
    print(finishedSoul.description)
  }
}

