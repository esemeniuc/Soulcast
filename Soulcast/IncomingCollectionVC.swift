//
//  IncomingCollectionVC.swift
//  SwiftGround
//
//  Created by June Kim on 2016-09-07.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

class IncomingCollectionVC: UICollectionViewController {
  
  let cellIdentifier:String = NSStringFromClass(IncomingCollectionCell)
  
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
    collectionView!.backgroundColor = UIColor.lightGrayColor()
    collectionView?.registerClass(IncomingCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print("\(name()): collectionView didSelectItemAtIndexPath")
  }
  
}

extension IncomingCollectionVC: IncomingQueueDelegate {
  func didEnqueue() {
    collectionView?.insertItemsAtIndexPaths([NSIndexPath(forRow: max(soloQueue.count-1, 0), inSection: 0)])
    
  }
  
  func didDequeue() {
    collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
    
  }
  
  func didBecomeEmpty() {
    //dismiss self   
    willMoveToParentViewController(nil)
    view.removeFromSuperview()
    removeFromParentViewController()
    
    
  }
}
