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
  weak var delegate: HistoryVCDelegate?
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addTableView()
    dataSource.fetch()
    //
    view.addSubview(IntegrationTestButton(frame:CGRect(x: 10, y: 10, width: 100, height: 100)))
  }
  
  func addTableView() {
    let tableHeight = view.bounds.height * 0.95
    tableView.frame = CGRect(x: 0, y: view.bounds.height - tableHeight, width: screenWidth, height: tableHeight)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = dataSource
    tableView.allowsMultipleSelectionDuringEditing = false
    tableView.allowsMultipleSelection = false
    dataSource.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell()))
    tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: String(describing: UITableViewHeaderFooterView()))
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    soulPlayer.subscribe(self)
    startPlaylisting()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    soulPlayer.unsubscribe(self)
    deselectAllRows()
  }
  func startPlaylisting() {
    let first = IndexPath(row: 0, section: 0)
    tableView.selectRow(at: first, animated: true, scrollPosition: .none)
    selectedSoul = dataSource.soul(forIndex: 0)
    // play first soul
    soulPlayer.reset()
    if let thisSoul = selectedSoul {
      soulPlayer.startPlaying(thisSoul)
      playlisting = true
    }
  }
  func playNextSoul() {
    if selectedSoul != nil {
      let nextIndex = dataSource.indexPath(forSoul: selectedSoul!).row + 1
      let nextIndexPath = IndexPath(item: nextIndex , section: 0)
      selectedSoul = dataSource.soul(forIndex: nextIndex)
      tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    }
    if selectedSoul != nil {
      soulPlayer.reset()
      soulPlayer.startPlaying(selectedSoul)
    }
  }
  
  func refresh(_ refreshControl:UIRefreshControl) {
    dataSource.fetch()
  }
  
  // UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    playlisting = false
    selectedSoul = dataSource.soul(forIndex:indexPath.row)
    if SoulPlayer.playing {
      soulPlayer.reset()
      tableView.deselectRow(at: indexPath, animated: true)
    } else {
      soulPlayer.reset()
      soulPlayer.startPlaying(selectedSoul)
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView(reuseIdentifier: String(describing: UITableViewHeaderFooterView()))
    return headerView
  }
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Block"
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55
  }
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    soulPlayer.reset()
    selectedSoul = nil
  }
  // HistoryDataSourceDelegate
  func willFetch() {
    //show loading
    refreshControl.beginRefreshing()
  }
  
  func didFetch(_ success: Bool) {
    if success {
      
    } else {
      //show failure, retry button.
    }
    refreshControl.endRefreshing()
  }
  
  func didUpdate(_ soulcount: Int) {
    tableView.reloadData()
  }
  func didFinishUpdating(_ soulCount: Int) {
    guard isViewLoaded && view.window != nil else {
      return
    }
    tableView.reloadData()
    //TODO:
//    if !startedPlaylisting {
      startPlaylisting()
//    }
    startedPlaylisting = true
  }
  func didRequestBlock(_ soul: Soul) {
    present(blockAlertController(soul), animated: true) {
      //
    }
    return
    
  }
  fileprivate func block(_ soul:Soul) {
    ServerFacade.block(soul, success: {
      //remove soul at index
      self.dataSource.remove(soul)
    }) { statusCode in
      print(statusCode)
    }
  }
  
  func blockAlertController(_ soul:Soul) -> UIAlertController {
    let controller = UIAlertController(title: "Block Soul", message: "You will no longer hear from the device that casted this soul.", preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Block", style: .default, handler: {(action) in
      self.block(soul)
    }))
    controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
      //
    }))
    return controller
  }
  
  
  //SoulPlayerDelegate
  func didStartPlaying(_ soul:Soul) {
    
  }
  func didFinishPlaying(_ soul:Soul) {
    //deselect current row if same
    if soul == selectedSoul {
      tableView.deselectRow(at: dataSource.indexPath(forSoul: soul) as IndexPath, animated: true)
    }
    if playlisting {
      playNextSoul()
    }
  }

  func didFailToPlay(_ soul:Soul) {
    
  }
  
  func deselectAllRows() {
    for rowIndex in 0...dataSource.soulCount() {
      let indexPath = IndexPath(row: rowIndex, section: 0)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  

}
