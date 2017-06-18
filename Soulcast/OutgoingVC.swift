

import UIKit

protocol OutgoingVCDelegate: class {
  func outgoingRadius() -> Double
  func outgoingLongitude() -> Double
  func outgoingLatitude() -> Double
  func outgoingDidStart()
  func outgoingDidStop()
}

class OutgoingVC: UIViewController {
  var soulType = SoulType.Broadcast
  var buttonSize:CGFloat = screenWidth * 0.28
  var outgoingButton: RecordButton!
  let inset:CGFloat = 15
  
  var progress : CGFloat! = 0 //progress bar for the outgoing button
    
  var outgoingSoul:Soul?
  var recordingStartTime:Date!
  var soulCaster = SoulCaster()
  var displayLink: CADisplayLink!
  
  var maxRecordingDuration: Int {
    get { return Recorder.maxDuration }
    set { Recorder.maxDuration = newValue }
  }
  
  var firstTime:Bool {
    get {
      if let defaults = UserDefaults.standard.value(forKey: "recordingFirstTime") as? Bool{
        return defaults
      } else {
        return true
      }
    }
    set {  UserDefaults.standard.setValue(newValue, forKey: "recordingFirstTime") }
  }
  
  weak var delegate: OutgoingVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addDisplayLink()
    addOutgoingButton()
    configureNetworking()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //requestStartRecording()
  }

  func configureNetworking() {
    soulCaster.delegate = self
  }
  
  func addOutgoingButton() {
    view.frame = CGRect(x: (screenWidth - buttonSize)/2, y: screenHeight - buttonSize - inset, width: buttonSize, height: buttonSize)
    outgoingButton = RecordButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
    outgoingButton.backgroundColor = UIColor.clear
    outgoingButton.progressColor = UIColor.red
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedDown(_:)), for: UIControlEvents.touchDown)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedUpInside(_:)), for: UIControlEvents.touchUpInside)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchDraggedExit(_:)), for: UIControlEvents.touchDragExit)
    
    view.addSubview(outgoingButton)
  }
  
  func outgoingButtonTouchedDown(_ button:UIButton) {
    if firstTime && !PermissionController.hasAudioPermission {
      //ask for recording permissions
//      Recorder.askForMicrophonePermission({
//        self.firstTime = false
//        }, failure: {
//          self.firstTime = true
//          //display can't do anything message
//      })
      return
    }
    if !Player.playing {
      requestStartRecording()
    }
  }
  
  func outgoingButtonTouchedUpInside(_ button:UIButton) {
    Recorder.requestStopRecording(subscriber: self)
  }
  
  func outgoingButtonTouchDraggedExit(_ button:UIButton) {
    Recorder.requestStopRecording(subscriber: self)
  }
    
  
  func addDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(OutgoingVC.displayLinkFired(_:)))
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
  }
  
  func displayLinkFired(_ link:CADisplayLink) {
    if Recorder.state == .recordingStarted || Recorder.state == .recordingLongEnough {
      incrementRecordingIndicator()
    }
    
  }
  func incrementRecordingIndicator() {
    //TODO: query soulRecorder to update UI.
//    let progress = Float(soulRecorder.displayCounter) / Float(soulRecorder.maximumRecordDuration) / 60
    
  }
  
  func requestStartRecording() {
    recordingStartTime = Date()
    Recorder.startRecording(subscriber: self)
    //HAX to get the view to change state
   
  }
  
  func requestFinishRecording() {
    Recorder.requestStopRecording(subscriber: self)
    //replay, save, change ui to disabled.
  }
  
  func playbackSoul(_ localSoul:Soul) {
    if let url = localSoul.voice.localURL {
      Player.play(url: URL.init(string: url)!, subscriber: self)
    }
  }
  
  
  func animateNegativeShake() {
    //left to right a couple times, disable button in the meanwhile.
    print("Animate nega shake here")
    outgoingButton.shakeInDenial()
  }
  
}

extension OutgoingVC: RecorderSubscriber {
  func recorderReachedMinDuration() {
     outgoingButton.tintLongEnough()
  }

  
  func recorderStarted() {
    outgoingButton.startProgress()
  }
  
  func recorderRecording(_ progress: CGFloat) {
    let haxProgress = progress + 1/60
    outgoingButton.setProgress(haxProgress)

  }
  
  func recorderFinished(_ localURL: URL) {
    let newSoul = Soul(voice: Voice(
      epoch: Int(Date().timeIntervalSince1970),
      s3Key: Randomizer.randomString(withLength: 10) + ".mp3",
      localURL: localURL.absoluteString))
    outgoingButton.mute()
    playbackSoul(newSoul)
    
    
    newSoul.radius = delegate?.outgoingRadius()
    newSoul.longitude = delegate?.outgoingLongitude()
    newSoul.latitude = delegate?.outgoingLatitude()
    newSoul.deviceID = Device.id ?? -1
    newSoul.type = soulType
    
    soulCaster.cast(newSoul)
    
    if !PermissionController.hasPushPermission {
      AppDelegate.registerForPushNotifications(UIApplication.shared)
    }
    
    delegate?.outgoingDidStart()
  }
  
  func recorderFailed() {
    animateNegativeShake()
    outgoingButton.resetFail()
    tryShowExplainFailAlert()
  }
  
  func tryShowExplainFailAlert() {
    let defaults = UserDefaults.standard
    let alertedCount = (defaults.value(forKey: "explainFailAlertedCount") as? Int) ?? 0
    
    if alertedCount < 3 {
      let alert = UIAlertController(title: "Recording is not long enough", message: "Tap and hold the button to record a soul", preferredStyle: .alert)
      let cancel = UIAlertAction(title: "OK", style: .cancel) { alert in
        //
      }
      alert.addAction(cancel)
      present(alert, animated: false) {
        //
      }
      defaults.setValue(alertedCount + 1, forKey: "explainFailAlertedCount")
    }
  }
  
  
}


extension OutgoingVC: SoulCasterDelegate {
  func soulDidStartUploading() {
    printline("soulDidStartUploading")
  }
  func soulIsUploading(_ progress:Float) {
    printline("soulIsUploading progress: \(progress)")
  }
  func soulDidFinishUploading(_ soul:Soul) {
    printline("soulDidFinishUploading")
    
  }
  func soulDidFailToUpload() {
    printline("soulDidFailToUpload")
    outgoingButton.resetFail()
  }
  func soulDidReachServer() {
    printline("soulDidReachServer")
  }
}

extension OutgoingVC: PlayerSubscriber {
  func playerStarted() {
    
  }
  func playerFinished(_ url: URL) {
    outgoingButton.resetSuccess()
    delegate?.outgoingDidStop()
  }
  func playerFailed() {
    
  }
}
