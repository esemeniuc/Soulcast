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
  func historyDidSelect(soul: Soul)
}

///displays a list of souls played in the past in reverse chronological order since 24 hours ago
class HistoryVC: UIViewController, UITableViewDelegate, SoulPlayerDelegate, HistoryDataSourceDelegate, UIViewControllerTransitioningDelegate, DetailModalVCDelegate {
  //title label
  let tableView = UITableView()//table view
  let dataSource = HistoryDataSource()
  var selectedSoul: Soul?
  var playlisting: Bool = false
  weak var delegate: HistoryVCDelegate?
  let refreshControl = UIRefreshControl()
  let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  var fetchToken = true
  var fetchFinishToken = true
  let zoomAnimator = ZoomTransitionAnimationController()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addTableView()
    addLoadingIndicator()
    addPullToRefreshHintView()
    addDismissButton()
    //
//    view.addSubview(IntegrationTestButton(frame:CGRect(x: 10, y: 10, width: 100, height: 100)))
  }
  func addPullToRefreshHintView() {
    let hintView = UILabel(frame: CGRect(
      x: 0, y: 3,
      width: view.frame.width,
      height: 20))
    hintView.textAlignment = .center
    hintView.textColor = .lightGray
    hintView.text = "Pull to refresh"
    hintView.font = UIFont.systemFont(ofSize: 12)
    view.addSubview(hintView)
  }
  func addLoadingIndicator() {
    let size:CGFloat = 60
    loadingIndicator.frame = CGRect(
      x: (tableView.frame.width-size)/2,
      y: (tableView.frame.height-size)/2,
      width: size, height: size)
    view.addSubview(loadingIndicator)
    loadingIndicator.startAnimating()
    loadingIndicator.hidesWhenStopped = true
  }
  
  func addDismissButton() {
    let dismissButton = UIButton()
    dismissButton.imageView?.contentMode = .scaleAspectFit
    dismissButton.setBackgroundImage(UIImage(named:"xicon"), for: .normal)
    dismissButton.frame = CGRect(x: 15, y: view.frame.height - 50, width: 35, height: 35)
    view.addSubview(dismissButton)
    dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
  }
  
  func dismissVC() {
    dismiss(animated: true) { 
      //
    }
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
    if fetchToken {
      dataSource.fetch()
      refreshControl.endRefreshing()
      loadingIndicator.stopAnimating()
      fetchToken = false
    }
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
    guard let soul = selectedSoul else {
      return
    }
    let path = dataSource.indexPath(forSoul: soul)
    if path.count != 0 {
      let nextIndex = path.row + 1
      let nextIndexPath = IndexPath(item: nextIndex , section: 0)
      selectedSoul = dataSource.soul(forIndex: nextIndex)
      tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    } else {
      print("playNextSoul path.count == 0")
    }
    if selectedSoul != nil {
      soulPlayer.reset()
      soulPlayer.startPlaying(selectedSoul)
    }
  }
  
  func refresh(_ refreshControl:UIRefreshControl) {
    dataSource.fetch()
  }
  
  func addDetailModal(_ soul:Soul) {
    let modalVC = DetailModalVC(soul: soul)
    modalVC.delegate = self
    addChildVC(modalVC)
  }
  
  func removeDetailModal(_ vc:UIViewController) {
    removeChildVC(vc)
  }
  
//// UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    playlisting = false
    soulPlayer.reset()
    if let selectedSoul = dataSource.soul(forIndex:indexPath.row) {
      delegate?.historyDidSelect(soul: selectedSoul)
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView(reuseIdentifier: String(describing: UITableViewHeaderFooterView()))
    if headerView.tag != 420 {
      //add
      let playAllButton = playlistButton()
      playAllButton.frame = CGRect(
        x: tableView.width - 90, y:0,
        width: 90,
        height: self.tableView(tableView, heightForHeaderInSection: 0)
      )
      headerView.addSubview(playAllButton)
    }
    headerView.tag = 420
    return headerView
  }
  func playlistButton() -> UIButton {
    let playButton = UIButton(type: .system)
    playButton.addTarget(self, action: #selector(didTapPlayAllButton), for: .touchUpInside)
    playButton.setTitle("Play All", for: .normal)
    return playButton
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
    return "!"
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
    DispatchQueue.main.sync {
      self.refreshControl.endRefreshing()
      if dataSource.soulCount() == 0 {
        self.loadingIndicator.stopAnimating()
      }
    }
  }
  
  func didUpdate(_ soulcount: Int) {
    if fetchFinishToken {
      loadingIndicator.stopAnimating()
      fetchFinishToken = false
    }
    tableView.reloadData()
  }
  func didFinishUpdating(_ soulCount: Int) {
    guard isViewLoaded && view.window != nil else {
      return
    }
    tableView.reloadData()
  }
  
  func didTapPlayAllButton() {
    startPlaylisting()
  }

  func didTapExclamation(_ soul: Soul) {
    present(Inappropriate.VC(
      reportHandler: { action in
        self.hideExclamation()
        self.present(Inappropriate.reportSelectAlert {
          (reason) in
          self.report(soul, reason.rawValue)
          self.present(Inappropriate.reportAffirmationAlert())
        })
    }, blockHandler: { action in
      self.hideExclamation()
      self.present(Inappropriate.blockConfirmAlert {
        self.block(soul)
        self.present(Inappropriate.blockAffirmationAlert())
      })
    }))
  }
  
  func hideExclamation() {
    self.tableView.setEditing(false, animated: true)
  }
  
  fileprivate func block(_ soul:Soul) {
    ServerFacade.block(soul, success: {
      //remove soul at index
      self.dataSource.remove(soul)
      self.tableView.reloadData()
    }) { statusCode in
      print(statusCode)
    }
  }
  fileprivate func report(_ soul:Soul, _ reason:String) {
    ServerFacade.report(soul)
  }
  
  
  
  //SoulPlayerDelegate
  func didStartPlaying(_ soul:Soul) {
    
  }
  func didFinishPlaying(_ soul:Soul) {
    //deselect current row if same
    if soul == selectedSoul {
      tableView.deselectRow(at: dataSource.indexPath(forSoul: soul) as IndexPath, animated: true)
    }
    if playlisting { playNextSoul() }
  }

  func didFailToPlay(_ soul:Soul) {
    
  }
  
  func deselectAllRows() {
    for rowIndex in 0...dataSource.soulCount() {
      let indexPath = IndexPath(row: rowIndex, section: 0)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func detailModalCancelled(_ vc: UIViewController) {
    removeDetailModal(vc)
  }
  
}
