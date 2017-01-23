  //
//  HistoryDataSource.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol HistoryDataSourceDelegate: class {
  func willFetch()
  func didFetch(_ success:Bool)
  func didUpdate(_ soulCount:Int)
  func didFinishUpdating(_ soulCount:Int)
  func didRequestBlock(_ soul: Soul)
}

class HistoryDataSource: NSObject, SoulCatcherDelegate {
  fileprivate var souls = [Soul]() 
  fileprivate var soulCatchers = Set<SoulCatcher>()
  weak var delegate: HistoryDataSourceDelegate?
  var updateTimer: Timer = Timer()
  
  func fetch() {
    //TODO:
    delegate?.willFetch()
    ServerFacade.getHistory({ souls in
      self.catchSouls(souls)
      self.delegate?.didFetch(true)
      }, failure:  { failureCode in
        self.delegate?.didFetch(false)
    })
  }
  func startTimer() {
    updateTimer.invalidate()
    updateTimer = Timer.scheduledTimer(
      timeInterval: 0.25,
      target: self,
      selector: #selector(timerExpired),
      userInfo: nil,
      repeats: false)
  }
  func timerExpired() {
    updateTimer.invalidate()
//    assertSorted()
    delegate?.didFinishUpdating(souls.count)
    print("HistoryDataSource timerExpired!!")
  }
  func assertSorted() {
    for soulIndex in 0...(souls.count-1) {
      assert(souls[soulIndex].epoch > souls[soulIndex + 1].epoch)
    }
  }
  func soul(forIndex index:Int) -> Soul? {
    guard index < souls.count else {
      return nil
    }
    return souls[index]
  }
  func indexPath(forSoul soul:Soul) -> IndexPath {
    if let index = souls.index(of: soul) {
      return IndexPath(row: index, section: 0)
    }
    return IndexPath()
  }
  func catchSouls(_ souls:[Soul]) {
    soulCatchers.removeAll(keepingCapacity: true)
    self.souls.removeAll(keepingCapacity: true)
    for eachSoul in souls {
      let catcher = SoulCatcher(soul: eachSoul)
      catcher.delegate = self
      soulCatchers.insert(catcher)
      
    }
  }
  func remove(_ soul:Soul) {
    if let index = souls.index(of: soul) {
      souls.remove(at: index)
      delegate?.didUpdate(souls.count)
    }
  }
  func insertByEpoch(_ soul: Soul) {
    var insertionIndex =  0
    for eachSoul in souls {
      if eachSoul.epoch > soul.epoch {
        insertionIndex = indexPath(forSoul: eachSoul).row + 1
      }
    }
    souls.insert(soul, at: insertionIndex)
    delegate?.didUpdate(souls.count)
  }
  
  func debugEpoch() {
    for eachSoul in souls {
      print(eachSoul.epoch!)
    }
    print(" ")
  }
  
  //SoulCatcherDelegate
  
  func soulDidStartToDownload(_ catcher: SoulCatcher, soul: Soul) {
    //
  }
  func soulIsDownloading(_ catcher: SoulCatcher, progress: Float) {
    //
  }
  func soulDidFinishDownloading(_ catcher: SoulCatcher, soul: Soul) {
    insertByEpoch(soul)
    soulCatchers.remove(catcher)
    startTimer()
  }
  func soulDidFailToDownload(_ catcher: SoulCatcher) {
    //
    soulCatchers.remove(catcher)
  }
  func soulCount() -> Int {
    return souls.count
  }
}

extension HistoryDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return souls.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Recent Souls"
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return ""
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      if let blockingSoul = soul(forIndex: indexPath.row) {
        delegate?.didRequestBlock(blockingSoul)
      }
    case .insert:      break
    case .none:      break
    }
  }
  

  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell()))
    if let thisSoul = soul(forIndex: indexPath.row),
      let epoch = thisSoul.epoch,
      let radius = thisSoul.radius {
      
      cell.textLabel?.text = timeAgo(epoch: epoch)
      cell.detailTextLabel?.text = String(round(radius*10)/10) + "km away"
      cell.detailTextLabel?.textColor = UIColor.gray
      cell.accessoryType = .disclosureIndicator
    }
    return cell
  }
}
