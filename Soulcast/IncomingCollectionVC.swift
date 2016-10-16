//
//  IncomingCollectionVC.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol IncomingCollectionVCDelegate {
  func didRunOutOfSouls()
}

class IncomingCollectionVC: UICollectionViewController {
  private static let inset:CGFloat = 8
  private static let topSpaceProportion:CGFloat = 0.38
  static var beforeFrame = CGRect(
    x: inset,
    y: screenHeight,
    width: screenWidth - inset * 2,
    height: screenHeight * (1-topSpaceProportion))
  static var afterFrame = CGRect(
    x: inset,
    y: screenHeight * topSpaceProportion,
    width: screenWidth - inset * 2,
    height: screenHeight * (1-topSpaceProportion))
  let cellIdentifier:String = NSStringFromClass(IncomingCollectionCell)
  var delegate:IncomingCollectionVCDelegate?
  
  init() {
    super.init(collectionViewLayout: IncomingCollectionFlowLayout())
    collectionView?.delegate = self
    collectionView?.dataSource = soloQueue
    soloQueue.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView!.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.6)
    collectionView?.registerClass(IncomingCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print("\(name()): collectionView didSelectItemAtIndexPath")
    if indexPath.row == 0 {
      enableReporting()
      if let incomingCell = collectionView.cellForItemAtIndexPath(indexPath) as? IncomingCollectionCell {
        incomingCell.delegate = self
      }
    }
  }
  

  
  func notifyUserReported() {
    let reportMessage = UIAlertController(title: "Reported", message: "This soul has been reported to the developers. We will take a closer look and take appropriate action!", preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
      //
    }
    reportMessage.addAction(okAction)
    presentViewController(reportMessage, animated: true) { 
      //
    }
  }
  
  private func playFirstSoul() {
    soulPlayer.subscribe(self)
    soulPlayer.startPlaying(soloQueue.peek())
  }
  
  func enableReporting() {
    let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    if let collectionCell = cell as? IncomingCollectionCell {
      collectionCell.showReportButton()
    }
  }
}

extension IncomingCollectionVC: IncomingQueueDelegate {
  func didEnqueue() {
    if soloQueue.count == 1 {
      collectionView?.reloadData()
    } else {
      collectionView?.insertItemsAtIndexPaths([NSIndexPath(forRow: max(soloQueue.count-1, 0), inSection: 0)])
    }
    //if only item, and player isn't playing, dequeue.
    if soloQueue.count == 1 && !SoulPlayer.playing {
      playFirstSoul()
    }
  }
  
  func didDequeue() {
    collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])

  }
  
  func didBecomeEmpty() {
    self.delegate?.didRunOutOfSouls()
    
  }
}

extension IncomingCollectionVC: SoulPlayerDelegate {
  func didStartPlaying(soul: Soul) {

  }
  
  func didFinishPlaying(soul: Soul) {
    soloQueue.dequeue()
    if (isActiveOnScreen()) {
      if !soloQueue.isEmpty {
        playFirstSoul()
      }

    } else {
      soloQueue.purge()
    }
  }
  
  func didFailToPlay(soul: Soul) {
    //
  }
  
}

extension IncomingCollectionVC: IncomingCollectionCellDelegate {
  func didTapReport() {
    reportFirstSoul()
    notifyUserReported()
  }
  func reportFirstSoul() {
    if let peekSoul = soloQueue.peek() {
      ServerFacade.report(peekSoul)
    }
  }
  
}
