

import UIKit

protocol OutgoingVCDelegate {
  func outgoingRadius() -> Double
  func outgoingLongitude() -> Double
  func outgoingLatitude() -> Double
  func outgoingDidStart()
  func outgoingDidStop()
}

class OutgoingVC: UIViewController {
  
  var buttonSize:CGFloat = screenWidth * 0.28
  var outgoingButton: RecordButton!
  let inset:CGFloat = 15
  
  var progress : CGFloat! = 0 //progress bar for the outgoing button
    
  var outgoingSoul:Soul?
  var recordingStartTime:NSDate!
  var soulRecorder = SoulRecorder()
  var soulCaster = SoulCaster()
  var displayLink: CADisplayLink!
  
  var firstTime:Bool {
    get {
      if let defaults = NSUserDefaults.standardUserDefaults().valueForKey("recordingFirstTime") as? Bool{
        return defaults
      } else {
        return true
      }
    }
    set {  NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "recordingFirstTime") }
  }
  
  var delegate: OutgoingVCDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addDisplayLink()
    addOutgoingButton()
    configureAudio()
    configureNetworking()
  }
  
  override func viewDidAppear(animated: Bool) {
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
    view.frame = CGRectMake((screenWidth - buttonSize)/2, screenHeight - buttonSize - inset, buttonSize, buttonSize)
    outgoingButton = RecordButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
    outgoingButton.backgroundColor = UIColor.clearColor()
    outgoingButton.progressColor = UIColor.redColor()
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedDown(_:)), forControlEvents: UIControlEvents.TouchDown)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchDraggedExit(_:)), forControlEvents: UIControlEvents.TouchDragExit)
    
    view.addSubview(outgoingButton)
  }
  
  func outgoingButtonTouchedDown(button:UIButton) {
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
  
  func outgoingButtonTouchedUpInside(button:UIButton) {
        requestFinishRecording()
  }
  
  func outgoingButtonTouchDraggedExit(button:UIButton) {
    requestFinishRecording()
  }
    
  
  func addDisplayLink() {
    displayLink = CADisplayLink(target: self, selector: #selector(OutgoingVC.displayLinkFired(_:)))
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
  }
  
  func displayLinkFired(link:CADisplayLink) {
    if soulRecorder.state == .RecordingStarted || soulRecorder.state == .RecordingLongEnough {
      incrementRecordingIndicator()
    }
    
  }
  func incrementRecordingIndicator() {
    //TODO: query soulRecorder to update UI.
//    let progress = Float(soulRecorder.displayCounter) / Float(soulRecorder.maximumRecordDuration) / 60
    
  }
  
  func requestStartRecording() {
    recordingStartTime = NSDate()
    soulRecorder.pleaseStartRecording()
    //HAX to get the view to change state
   
  }
  
  func requestFinishRecording() {
    soulRecorder.pleaseStopRecording()
    //replay, save, change ui to disabled.
  }
  
  func playbackSoul(localSoul:Soul) {
    soulPlayer.startPlaying(localSoul)
  }
  
  
  func animateNegativeShake() {
    //left to right a couple times, disable button in the meanwhile.
    print("Animate nega shake here")
    outgoingButton.shakeInDenial()
  }
  
}

extension OutgoingVC: SoulRecorderDelegate {
  func soulDidStartRecording() {
    outgoingButton.startProgress()
    
  }
  
  func soulIsRecording(progress: CGFloat) {
    let haxProgress = progress + 1/60
    outgoingButton.setProgress(haxProgress)
  }
  
  func soulDidFailToRecord() {
    animateNegativeShake()
    outgoingButton.resetFail()
    
  }
  
  func soulDidReachMinimumDuration() {
    outgoingButton.tintLongEnough()
  }
    
  func soulDidFinishRecording(newSoul: Soul) {
    outgoingButton.mute()
    playbackSoul(newSoul)
    newSoul.epoch = Int(NSDate().timeIntervalSince1970)
    newSoul.radius = delegate?.outgoingRadius()
    newSoul.s3Key = String(newSoul.epoch!)
    newSoul.longitude = delegate?.outgoingLongitude()
    newSoul.latitude = delegate?.outgoingLatitude()
    newSoul.token = Device.localDevice.token
    newSoul.type = .Broadcast
    
    soulCaster.cast(newSoul)

    if !PermissionController.hasPushPermission {
      AppDelegate.registerForPushNotifications(UIApplication.sharedApplication())
    }

  }
}


extension OutgoingVC: SoulCasterDelegate {
  func soulDidStartUploading() {
    printline("soulDidStartUploading")
  }
  func soulIsUploading(progress:Float) {
    printline("soulIsUploading progress: \(progress)")
  }
  func soulDidFinishUploading(soul:Soul) {
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
    func didStartPlaying(soul:Soul){
        
    }
    func didFinishPlaying(soul:Soul){
        outgoingButton.resetSuccess()
    }
    func didFailToPlay(soul:Soul){
        
    }
}
