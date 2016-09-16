//
//  FeedbackVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-16.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol FeedbackVCDelegate {
  func didFinishGettingFeedback()
}

class FeedbackVC: UIViewController {
  
  let feedbackRecorder = SoulRecorder()
  let feedbackCaster = SoulCaster()
  
  var recordButton:RecordButton!
  
  let descriptionText = "Please give us feedback about this app, such as what features you'd like to see, or any improvement you can think of. The developers will get a push notification as soon as you record. We're listening!"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layoutStuff()
    configureAudio()
    
    view.backgroundColor = UIColor.yellowColor()
    
  }
  
  func layoutStuff() {
    addRecordButton()
    addDescriptionLabel()
  }
  
  func configureAudio() {
    feedbackRecorder.delegate = self
    feedbackCaster.delegate = self
  }
  
  func addRecordButton() {
    recordButton = RecordButton(width: view.bounds.width/4, height: view.bounds.width/4)
    recordButton.center = CGPointMake(CGRectGetWidth(view.bounds)/2, CGRectGetHeight(view.bounds) - recordButton.height - 10)
    view.addSubview(recordButton)
  }
  
  func addDescriptionLabel() {
    let inset:CGFloat = 10
    let descriptionLabel = UILabel(frame: CGRect(
      x: inset,
      y: inset,
      width: view.bounds.width - 2 * inset,
      height: view.bounds.width - 2 * inset))
    descriptionLabel.backgroundColor = UIColor.cyanColor()
    descriptionLabel.text = descriptionText
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = UIColor.darkGrayColor()
    descriptionLabel.font = UIFont(name: HelveticaNeue, size: 14)
    view.addSubview(descriptionLabel)
  }
  
}

extension FeedbackVC: SoulRecorderDelegate {
  func soulDidStartRecording() {
    
  }
  func soulIsRecording(progress:CGFloat) {
    
  }
  func soulDidFinishRecording(newSoul: Soul) {
    
  }
  func soulDidFailToRecord() {
    
  }
  func soulDidReachMinimumDuration() {
    
  }
}

extension FeedbackVC: SoulCasterDelegate {
  func soulDidStartUploading() {
    
  }
  func soulIsUploading(progress:Float) {
    
  }
  func soulDidFinishUploading(soul:Soul) {
    
  }
  func soulDidFailToUpload() {
    
  }
  func soulDidReachServer() {
    
  }
}
