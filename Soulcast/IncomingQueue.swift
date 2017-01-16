

import Foundation
import UIKit

let soloQueue = IncomingQueue()

protocol IncomingQueueDelegate: class {
  func didEnqueue()
  func didDequeue()
  func didBecomeEmpty()
}

class IncomingQueue: NSObject, UICollectionViewDataSource {
  let cellIdentifier:String = NSStringFromClass(IncomingCollectionCell)
  var count:Int {return soulQueue.count}
  fileprivate let soulQueue = Queue<Soul>()
  weak var delegate:IncomingQueueDelegate?
  
  func enqueue(_ someSoul:Soul) {
    soulQueue.append(someSoul)
    delegate?.didEnqueue()
  }
  var isEmpty:Bool { return count == 0 }
  func peek() -> Soul? {
    return soulQueue.head?.value
  }
  func purge() {
    for _ in 0...count {
      soulQueue.dequeue()
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
    var someNode = soulQueue.head
    if indexPath.row != 0 {
      for _ in 1 ... indexPath.row {
        someNode = someNode?.next
      }
    }
    let theSoul = someNode!.value
    cell.radius = Float(theSoul.radius!)
    cell.epoch = theSoul.epoch!
    return cell
    
  }
  
  
  
}



// singly rather than doubly linked list implementation
// private, as users of Queue never use this directly
private final class QueueNode<T> {
  // note, not optional – every node has a value
  var value: T
  // but the last node doesn't have a next
  var next: QueueNode<T>? = nil
  
  init(value: T) { self.value = value }
}

// Ideally, Queue would be a struct with value semantics but
// I'll leave that for now
public final class Queue<T> {
  // note, these are both optionals, to handle
  // an empty queue
  fileprivate var head: QueueNode<T>? = nil
  fileprivate var tail: QueueNode<T>? = nil
  
  public init() { }
}

extension Queue {
  // append is the standard name in Swift for this operation
  public func append(_ newElement: T) {
    let oldTail = tail
    self.tail = QueueNode(value: newElement)
    if  head == nil { head = tail }
    else { oldTail?.next = self.tail }
  }
  
  public func dequeue() -> T? {
    if let head = self.head {
      self.head = head.next
      if head.next == nil { tail = nil }
      return head.value
    }
    else {
      return nil
    }
  }
}

public struct QueueIndex<T>: Comparable {
  /// Returns a Boolean value indicating whether the value of the first
  /// argument is less than that of the second argument.
  ///
  /// This function is the only requirement of the `Comparable` protocol. The
  /// remainder of the relational operator functions are implemented by the
  /// standard library for any type that conforms to `Comparable`.
  ///
  /// - Parameters:
  ///   - lhs: A value to compare.
  ///   - rhs: Another value to compare.
  public static func <(lhs: QueueIndex<T>, rhs: QueueIndex<T>) -> Bool {
    return lhs.node === rhs.node

  }

  fileprivate let node: QueueNode<T>?
  public func successor() -> QueueIndex<T> {
    return QueueIndex(node: node?.next)
  }
}

public func ==<T>(lhs: QueueIndex<T>, rhs: QueueIndex<T>) -> Bool {
  return lhs.node === rhs.node
}

extension Queue: MutableCollection {
  /// Returns the position immediately after the given index.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be less than
  ///   `endIndex`.
  /// - Returns: The index value immediately after `i`.
  public func index(after i: QueueIndex<T>) -> QueueIndex<T> {
    return i
  }

  public typealias Index = QueueIndex<T>
  public var startIndex: Index { return Index(node: head) }
  public var endIndex: Index { return Index(node: nil) }
  
  public subscript(idx: Index) -> T {
    get {
      precondition(idx.node != nil, "Attempt to subscript out of bounds")
      return idx.node!.value
    }
    set(newValue) {
      precondition(idx.node != nil, "Attempt to subscript out of bounds")
      idx.node!.value = newValue
    }
  }
  
  public typealias Iterator = IndexingIterator<Queue>
  public func makeIterator() -> Iterator {
    return Iterator(_elements: self)
  }
  
}

