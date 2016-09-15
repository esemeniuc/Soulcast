

import UIKit

protocol OutgoingVCDelegate {
  func outgoingRadius() -> Double
  func outgoingLongitude() -> Double
  func outgoingLatitude() -> Double
  func outgoingDidStart()
  func outgoingDidStop()
}

class OutgoingVC: UIViewController {
  
  var buttonSize:CGFloat = screenWidth * 1/3
  var outgoingButton: RecordButton!
  var progress : CGFloat! = 0 //progress bar for the outgoing button
    
  var outgoingSoul:Soul?
  var recordingStartTime:NSDate!
  var soulRecorder = SoulRecorder()
  var soulCaster = SoulCaster()
  var displayLink: CADisplayLink!
  
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

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OutgoingVC.soulDidFailToPlay(_:)), name: "soulDidFailToPlay", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OutgoingVC.soulDidFinishPlaying(_:)), name: "soulDidFinishPlaying", object: nil)
  }
  
  func configureNetworking() {
    soulCaster.delegate = self
  }
  
  func addOutgoingButton() {
    view.frame = CGRectMake((screenWidth - buttonSize)/2, screenHeight - buttonSize, buttonSize, buttonSize)
    outgoingButton = RecordButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
    outgoingButton.backgroundColor = UIColor.clearColor()
    outgoingButton.progressColor = UIColor.redColor()
    //TODO: simplest implementation first.
    //TODO: make pixel perfect.
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedDown(_:)), forControlEvents: UIControlEvents.TouchDown)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchedUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    outgoingButton.addTarget(self, action: #selector(OutgoingVC.outgoingButtonTouchDraggedExit(_:)), forControlEvents: UIControlEvents.TouchDragExit)
    
    view.addSubview(outgoingButton)
  }
  
  func outgoingButtonTouchedDown(button:UIButton) {
    print("outgoingButtonTouchedDown")
    
    if !SoulPlayer.playing {
      requestStartRecording()
    }
  }
  
  func outgoingButtonTouchedUpInside(button:UIButton) {
    print("outgoingButtonTouchedUpInside")
        requestFinishRecording()
  }
  
  func outgoingButtonTouchDraggedExit(button:UIButton) {
    print("outgoingButtonTouchDraggedExit")
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
    print("playbackSoul localSoul:\(localSoul)")
    //TODO: test to see if it mutes
    outgoingButton.setMutedDuringPlayBack()
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
        print("soulIsRecording with progress: \(progress)")
        let haxProgress = progress + 1/60
        outgoingButton.setProgress(haxProgress)
    }
  
  func soulDidFailToRecord() {
    print("SOUL FAILED TO RECORD: TOO SHORT")
    //negative animation, go back to being enabled
    animateNegativeShake()
    //TODO: control the views to indicate to user that soul failed
    outgoingButton.resetFail()
    
  }
  
  func soulDidReachMinimumDuration() {
    outgoingButton.tintLongEnough()
  }
    
  func soulDidFinishRecording(newSoul: Soul) {
    outgoingButton.resetSuccess()
    playbackSoul(newSoul)
    newSoul.epoch = Int(NSDate().timeIntervalSince1970)
    newSoul.radius = delegate?.outgoingRadius()
    newSoul.s3Key = String(newSoul.epoch!)
    newSoul.longitude = delegate?.outgoingLongitude()
    newSoul.latitude = delegate?.outgoingLatitude()
    newSoul.token = Device.localDevice.token
    newSoul.type = .Broadcast
    soulCaster.cast(newSoul)
    //TODO: optimize later by concurrently uploading data and metadata concurrently
//    soulCaster.castSoulToServer(newSoul)

  }
}

extension OutgoingVC {
  func soulDidFailToPlay(notification:NSNotification) {
    let failSoul = notification.object as! Soul
    print("soulDidFailToPlay failSoul: \(failSoul)")
  }
  
  func soulDidFinishPlaying(notification:NSNotification) {
//    let finishedSoul = notification.object as! Soul
    print("soulDidFinishPlaying")
    outgoingButton.resetSuccess()
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
