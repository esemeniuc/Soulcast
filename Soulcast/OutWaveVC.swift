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
  //TODO:
}

class OutWaveVC: UIViewController, SoulPlayerDelegate {
  var castSoul: Soul!
  let playButton = UIButton()
  let voiceVC = VoiceRecorderVC()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addPlayButton()
    addBackButton()
    addVoiceVC()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = false
    soulPlayer.subscribe(self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    soulPlayer.unsubscribe(self)
  }
  
  func addVoiceVC() {
    addChildViewController(voiceVC)
    voiceVC.view.frame = CGRect(x: 0, y: view.maxY - 100, width: view.width, height: 100)
    view.addSubview(voiceVC.view)
    voiceVC.didMove(toParentViewController: self)
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
    soulPlayer.startPlaying(castSoul)
    
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
    self.navigationController?.popViewController(animated: true)
  }
  
  ////// SoulPlayerDelegate
  func didStartPlaying(_ soul:Soul) {
    playButton.isEnabled = false
  }
  
  func didFinishPlaying(_ soul:Soul) {
    playButton.isEnabled = true
  }
  
  func didFailToPlay(_ soul:Soul) {
    
  }
  //////

}
