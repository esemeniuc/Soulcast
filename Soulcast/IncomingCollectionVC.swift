//
//  IncomingCollectionVC.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol IncomingCollectionVCDelegate: class {
  func didRunOutOfSouls(ivc:IncomingCollectionVC)
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
  weak var delegate:IncomingCollectionVCDelegate?
  
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
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    super.willMoveToParentViewController(parent)
    //TODO: animate
    view.frame = IncomingCollectionVC.beforeFrame
    UIView.animateWithDuration(0.3) { 
      self.view.frame = IncomingCollectionVC.afterFrame
    }
  }
  
  func animateAway(completion:()->()) {
    UIView.animateWithDuration(0.3, animations: { 
      self.view.frame = IncomingCollectionVC.beforeFrame
    }) { (success) in
      completion()
    }
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print("\(name()): collectionView didSelectItemAtIndexPath")
    
  }
  
  func stop() {
    animateAway { }
    soulPlayer.reset()
  }
  
  private func playFirstSoul() {
    soulPlayer.subscribe(self)
    soulPlayer.reset()
    soulPlayer.startPlaying(soloQueue.peek())
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
    if !SoulPlayer.playing {
      playFirstSoul()
      UIView.animateWithDuration(0.3) {
        self.view.frame = IncomingCollectionVC.afterFrame
      }
    }
  }
  
  func didDequeue() {
    collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])

  }
  
  func didBecomeEmpty() {
    self.delegate?.didRunOutOfSouls(self)
    
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
