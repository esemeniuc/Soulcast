//
//  VoiceRecorderVC.swift
//  Soulcast
//
//  Created by June Kim on 2017-04-23.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol VoiceRecorderVCDelegate: class {
  func recorderWillStart(_:VoiceRecorderVC)
  func recorderFailed(_:VoiceRecorderVC)
  func recorderFinished(_:VoiceRecorderVC, voice:Voice)
}

///combines recording ui and recording logic. To be used as a child VC
class VoiceRecorderVC: UIViewController, VoiceRecorderDelegate {
  weak var delegate: VoiceRecorderVCDelegate?
  var recordButton: RecordButton!
  var maxRecordingDuration: Int {
    get { return voiceRecorder.maximumRecordDuration }
    set { voiceRecorder.maximumRecordDuration = newValue }
  }
  var voiceRecorder = SoulRecorder()
  var buttonSize:CGFloat = screenWidth * 0.28
  var displayLink: CADisplayLink!
  var voice: Voice?
  var recordingStartTime:Date!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
    addRecordButton()
    configureAudio()
  }
  
  func addRecordButton() {
    view.frame = CGRect(
      x: (screenWidth - buttonSize)/2,
      y: screenHeight - buttonSize - 15,
      width: buttonSize, height: buttonSize)
    recordButton = RecordButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
    recordButton.backgroundColor = UIColor.clear
    recordButton.progressColor = UIColor.red
    recordButton.addTarget(self, action: #selector(requestStartRecording), for: .touchDown)
    recordButton.addTarget(self, action: #selector(requestFinishRecording), for: .touchUpInside)
    recordButton.addTarget(self, action: #selector(requestFinishRecording), for: .touchDragExit)
    view.addSubview(recordButton)
  }
  
  func configureAudio() {
    voiceRecorder.delegate = self
    voiceRecorder.setup()
  }
  
  func requestStartRecording() {
    recordingStartTime = Date()
    voiceRecorder.pleaseStartRecording()
    //HAX to get the view to change state
  }
  
  func requestFinishRecording() {
    voiceRecorder.pleaseStopRecording()
  }

  func playback(_ voice:Voice) {
    //voicePlayer.startPlaying(localSoul)
  }
  
  func soulDidStartRecording() {
    recordButton.startProgress()
  }
  func soulIsRecording(_ progress:CGFloat) {
    recordButton.setProgress(progress + 1/60)
  }
  func recorderDidFinishRecording(_ localURL: String) {
    let newVoice = Voice(
      epoch: Int(Date().timeIntervalSince1970),
      s3Key: Randomizer.randomString(withLength: 10) + ".mp3",
      localURL: localURL)
    soulPlayer.startPlaying(newVoice)
    delegate?.recorderFinished(self, voice: newVoice)
  }
  func soulDidFailToRecord() {
    delegate?.recorderFailed(self)
    recordButton.resetFail()
    tryShowExplainFailAlert()
  }
  func soulDidReachMinimumDuration() {
    recordButton.tintLongEnough()
  }
  func tryShowExplainFailAlert() {
    let alert = UIAlertController(title: "Recording is not long enough", message: "Tap and hold the button to record a soul", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "OK", style: .cancel)
    alert.addAction(cancel)
    present(alert, animated: true)
  }
}
