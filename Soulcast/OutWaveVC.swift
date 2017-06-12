//
//  OutWaveVC.swift
//  Soulcast
//
//  Created by June Kim on 2017-02-05.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol OutWaveVCDelegate: class {
  func outWaveDidCall(wave:Wave)
}

class OutWaveVC: UIViewController, PlayerSubscriber, VoiceRecorderVCDelegate {
  var castSoul: Soul!
  let playButton = UIButton()
  let descriptionLabel = UILabel()
  let voiceVC = VoiceRecorderVC()
  weak var delegate: OutWaveVCDelegate?
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addPlayButton()
    addBackButton()
    addDescriptionLabel()
    addVoiceVC()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Player.play(url: URL.init(string: castSoul.voice.localURL!)!, subscriber: self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  func addVoiceVC() {
    voiceVC.delegate = self
    addChildViewController(voiceVC)
    _ = voiceVC.view
    view.addSubview(voiceVC.view)
    voiceVC.didMove(toParentViewController: self)
  }
  
  func addDescriptionLabel() {
    descriptionLabel.frame = CGRect(
      x: 20, y: view.height/2,
      width: view.width - 40, height: view.height/4)
    descriptionLabel.text = "Send a message to the caster of this soul to start a one-to-one conversation!"
    descriptionLabel.numberOfLines = 0
    view.addSubview(descriptionLabel)
  }
  func addPlayButton() {
    let buttonSize:CGFloat = 80
    playButton.frame = CGRect(
      x: (view.width - buttonSize)/2,
      y: (view.height - buttonSize)/2,
      width: buttonSize, height: buttonSize)
    view.addSubview(playButton)
    playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
    playButton.setImage(imageFrom(systemItem: .play), for: .normal)
    playButton.setImage(imageFrom(systemItem: .pause), for: .disabled)
  }
  
  func didTapPlayButton() {
    Player.play(url: URL.init(string: castSoul.voice.localURL!)!, subscriber: self)

  }
  
  func addBackButton() {
    let backButton = UIButton()
    backButton.imageView?.contentMode = .scaleAspectFit
    backButton.setBackgroundImage(UIImage(named:"xicon"), for: .normal)
    backButton.frame = CGRect(x: 15, y: 25, width: 35, height: 35)
    view.addSubview(backButton)
    backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
  }
  
  func goBack() {
    self.navigationController!.popViewController(animated: true)
  }
  
  ////// SoulPlayerDelegate
  func playerStarted(){ playButton.isEnabled = false }
  func playerFinished(_ url: URL){ playButton.isEnabled = true }
  func playerFailed(){ }
  
  //////
  func recorderWillStart(_:VoiceRecorderVC) {
    playButton.isEnabled = false
  }
  func recorderFailed(_:VoiceRecorderVC) {
    playButton.isEnabled = true
  }
  func recorderFinished(_:VoiceRecorderVC, callVoice:Voice) {
    presentFinishedAlert()
    let callWave = Wave(incomingSoul: castSoul, call: callVoice)
    delegate?.outWaveDidCall(wave: callWave)
  }
  //////
  func presentFinishedAlert() {
    let finishedAlert = UIAlertController(
      title: "Waved", message: "You just waved at the soul caster",
      preferredStyle: .alert)
    finishedAlert.addAction(UIAlertAction(
      title: "OK", style: .cancel,
      handler: { (action) in self.goBack() }
    ))
    present(finishedAlert)
  }
}
