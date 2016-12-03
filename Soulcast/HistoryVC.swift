//
//  HistoryVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryVCDelegate: class {
  //TODO:
}

///displays a list of souls played in the past in reverse chronological order since 24 hours ago
class HistoryVC: UIViewController, UITableViewDelegate, SoulPlayerDelegate, HistoryDataSourceDelegate {
  //title label
  let tableView = UITableView()//table view
  let dataSource = HistoryDataSource()
  var selectedSoul: Soul?
  var playlisting: Bool = false
  var startedPlaylisting: Bool = false
  
  override func viewDidLoad() {
    addTableView()
  }
  weak var delegate: HistoryVCDelegate?
  
  func addTableView() {
    let tableHeight = view.bounds.height * 0.95
    tableView.frame = CGRect(x: 0, y: view.bounds.height - tableHeight, width: screenWidth, height: tableHeight)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = dataSource
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsMultipleSelection = false
    dataSource.delegate = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
    tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: String(UITableViewHeaderFooterView))
  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    dataSource.fetch()
    soulPlayer.subscribe(self)
    
  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    soulPlayer.unsubscribe(self)
  }
  func startPlaylisting() {
    let first = NSIndexPath(forRow: 0, inSection: 0)
    tableView.selectRowAtIndexPath(first, animated: true, scrollPosition: .None)
    selectedSoul = dataSource.soul(forIndex: 0)
    // play first soul
    soulPlayer.reset()
    soulPlayer.startPlaying(selectedSoul!)
    playlisting = true
  }
  func playNextSoul() {
    if selectedSoul != nil {
      let nextIndex = dataSource.indexPath(forSoul: selectedSoul!).row + 1
      let nextIndexPath = NSIndexPath(forItem: nextIndex , inSection: 0)
      selectedSoul = dataSource.soul(forIndex: nextIndex)
      tableView.selectRowAtIndexPath(nextIndexPath, animated: true, scrollPosition: .None)
    }
    if let soul = selectedSoul {
      soulPlayer.reset()
      soulPlayer.startPlaying(selectedSoul)
    }
  }
  
  // UITableViewDelegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    playlisting = false
    selectedSoul = dataSource.soul(forIndex:indexPath.row)
    if SoulPlayer.playing {
      soulPlayer.reset()
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    } else {
      soulPlayer.reset()
      soulPlayer.startPlaying(selectedSoul)
    }
  }
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView(reuseIdentifier: String(UITableViewHeaderFooterView))
    return headerView
  }
  func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55
  }
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
    return "Block"
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55
  }
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    soulPlayer.reset()
    selectedSoul = nil
  }
  // HistoryDataSourceDelegate
  func willFetch() {
    //show loading
  }
  
  func didFetch(success: Bool) {
    if success {
      
      //remove loading
    } else {
      //show failure, retry button.
    }
  }
  
  func didUpdate(soulcount: Int) {
    tableView.reloadData()
  }
  func didFinishUpdating(soulCount: Int) {
    //TODO:
    if !startedPlaylisting {
      startPlaylisting()
    }
    startedPlaylisting = true
  }
  func didConfirmBlock(soul: Soul) {
    MockServerFacade.block(soul, success: {
      //remove soul at index
      self.dataSource.remove(soul)
      }) { statusCode in
        print(statusCode)
    }
  }
  
  //SoulPlayerDelegate
  func didStartPlaying(soul:Soul) {
    
  }
  func didFinishPlaying(soul:Soul) {
    //deselect current row if same
    if soul == selectedSoul {
      tableView.deselectRowAtIndexPath(dataSource.indexPath(forSoul: soul), animated: true)
    }
    if playlisting {
      playNextSoul()
    }
  }
  func didFailToPlay(soul:Soul) {
    
  }
}
