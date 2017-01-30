

import Foundation
import UIKit

let soloQueue = IncomingQueue()

protocol IncomingQueueDelegate: class {
  func didEnqueue()
  func didDequeue()
  func didBecomeEmpty()
}

class IncomingQueue: NSObject, UICollectionViewDataSource {
  let cellIdentifier:String = NSStringFromClass(IncomingCollectionCell.self)
  var count:Int {return self.soulQueue.count}
  private var soulQueue = Queue<Soul>()
  weak var delegate:IncomingQueueDelegate?
  
  func enqueue(_ someSoul:Soul) {
    soulQueue.enqueue(someSoul)
    delegate?.didEnqueue()
  }
  var isEmpty:Bool { return count == 0 }
  func peek() -> Soul? {
    return soulQueue.front
  }
  func purge() {
    for _ in 0...count {
      _ = soulQueue.dequeue()
    }
  }
  
  func dequeue() -> Soul? {
    let tempSoul = soulQueue.dequeue()
    if tempSoul != nil {
      delegate?.didDequeue()
    }
    if soulQueue.count == 0 {
      self.delegate?.didBecomeEmpty()
    }
    return tempSoul
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return soulQueue.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! IncomingCollectionCell
    if let theSoul = soulQueue[indexPath.row] {
      cell.radius = Float(theSoul.radius!)
      cell.epoch = theSoul.epoch!
    }
    return cell
    
  }
  
  
  
}

public struct Queue<T> {
  fileprivate var array = [T]()
  
  public var count: Int {
    return array.count
  }
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public var front: T? {
    return array.first
  }

  public subscript(index: Int) -> T? {
    if index > array.count {
      return nil
    }
    return array[index]
  }
}
