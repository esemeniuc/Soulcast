

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
  var soulRecorder = SoulRecorder()
  var soulCaster = SoulCaster()
  var displayLink: CADisplayLink!
  
  var maxRecordingDuration: Int {
    get { return soulRecorder.maximumRecordDuration }
    set { soulRecorder.maximumRecordDuration = newValue }
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
    configureAudio()
    configureNetworking()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //requestStartRecording()
  }

  func configureAudio() {
    soulRecorder.delegate = self
    soulRecorder.setup()
    soulPlayer.subscribe(self)
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
      SoulRecorder.askForMicrophonePermission({ 
        self.firstTime = false
        }, failure: {
          self.firstTime = true
          //display can't do anything message
      })
      return
    }
    if !SoulPlayer.playing {
      requestStartRecording()
    }
  }
  
  func outgoingButtonTouchedUpInside(_ button:UIButton) {
    requestFinishRecording()
  }
  
  func outgoingButtonTouchDraggedExit(_ button:UIButton) {
    requestFinishRecording()
  }
    
  
  func addDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(OutgoingVC.displayLinkFired(_:)))
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
  }
  
  func displayLinkFired(_ link:CADisplayLink) {
    if soulRecorder.state == .recordingStarted || soulRecorder.state == .recordingLongEnough {
      incrementRecordingIndicator()
    }
    
  }
  func incrementRecordingIndicator() {
    //TODO: query soulRecorder to update UI.
//    let progress = Float(soulRecorder.displayCounter) / Float(soulRecorder.maximumRecordDuration) / 60
    
  }
  
  func requestStartRecording() {
    recordingStartTime = Date()
    soulRecorder.pleaseStartRecording()
    //HAX to get the view to change state
   
  }
  
  func requestFinishRecording() {
    soulRecorder.pleaseStopRecording()
    //replay, save, change ui to disabled.
  }
  
  func playbackSoul(_ localSoul:Soul) {
    soulPlayer.startPlaying(localSoul)
  }
  
  
  func animateNegativeShake() {
    //left to right a couple times, disable button in the meanwhile.
    print("Animate nega shake here")
    outgoingButton.shakeInDenial()
  }
  
}

extension OutgoingVC: VoiceRecorderDelegate {
  internal func recorderDidFinishRecording(_ localURL: String) {
    let newSoul = Soul(voice: Voice(
      epoch: Int(Date().timeIntervalSince1970),
      s3Key: Randomizer.randomString(withLength: 10) + ".mp3",
      localURL: localURL))
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

  func soulDidStartRecording() {
    outgoingButton.startProgress()
    
  }
  
  func soulIsRecording(_ progress: CGFloat) {
    let haxProgress = progress + 1/60
    outgoingButton.setProgress(haxProgress)
  }
  
  func soulDidFailToRecord() {
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
  
  func soulDidReachMinimumDuration() {
    outgoingButton.tintLongEnough()
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

extension OutgoingVC: SoulPlayerDelegate {
  func didStartPlaying(_ voice:Voice){
    
  }
  func didFinishPlaying(_ voice:Voice){
    outgoingButton.resetSuccess()
    delegate?.outgoingDidStop()
  }
  func didFailToPlay(_ voice:Voice){
    
  }
}
