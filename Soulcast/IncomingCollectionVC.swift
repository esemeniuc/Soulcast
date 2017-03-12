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
  func didRunOutOfSouls(_ ivc:IncomingCollectionVC)
}

class IncomingCollectionVC: UICollectionViewController {
  fileprivate static let inset:CGFloat = 8
  fileprivate static let topSpaceProportion:CGFloat = 0.38
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
  let cellIdentifier:String = NSStringFromClass(IncomingCollectionCell.self)
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
    collectionView!.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
    collectionView?.register(IncomingCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
    addDoubleTapToDismiss()
  }
  
  func addDoubleTapToDismiss() {
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    doubleTapRecognizer.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapRecognizer)
  }
  func doubleTapped() {
    soloQueue.purge()
    stop()
  }
  override func willMove(toParentViewController parent: UIViewController?) {
    super.willMove(toParentViewController: parent)
    view.frame = IncomingCollectionVC.beforeFrame
    
    UIView.animate(withDuration: 0.3, animations: { 
      self.view.frame = IncomingCollectionVC.afterFrame
    }) 
  }
  
  func animateAway(_ completion:@escaping ()->()) {
    UIView.animate(withDuration: 0.3, animations: { 
      self.view.frame = IncomingCollectionVC.beforeFrame
    }, completion: { (success) in
      completion()
    }) 
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("\(name()): collectionView didSelectItemAtIndexPath")
    
  }
  
  func stop() {
    animateAway { }
    soulPlayer.reset()
  }
  
  fileprivate func playFirstSoul() {
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
      collectionView?.insertItems(at: [IndexPath(row: max(soloQueue.count-1, 0), section: 0)])
    }
    //if only item, and player isn't playing, dequeue.
    if !SoulPlayer.playing {
      playFirstSoul()
      UIView.animate(withDuration: 0.3, animations: {
        self.view.frame = IncomingCollectionVC.afterFrame
      }) 
    }
  }
  
  func didDequeue() {
    collectionView?.deleteItems(at: [IndexPath(item: 0, section: 0)])

  }
  
  func didBecomeEmpty() {
    self.delegate?.didRunOutOfSouls(self)
    
  }
}

extension IncomingCollectionVC: SoulPlayerDelegate {
  func didStartPlaying(_ soul: Soul) {
    
  }
  
  func didFinishPlaying(_ soul: Soul) {
    _ = soloQueue.dequeue()
    if (isActiveOnScreen()) {
      if !soloQueue.isEmpty {
        playFirstSoul()
      }
    } else {
      soloQueue.purge()
    }
  }
  
  func didFailToPlay(_ soul: Soul) {
    //
  }
  
}
