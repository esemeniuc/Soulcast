//
//  HistoryVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-17.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

///displays a list of souls played in the past in reverse chronological order since 24 hours ago
class HistoryVC: UIViewController {
  //title label
  let tableView = UITableView()//table view
  let dataSource = HistoryDataSource()
  override func viewDidLoad() {
    addTableView()
  }
  
  func addTableView() {
    let tableHeight = view.bounds.height * 0.9
    tableView.frame = CGRect(x: 0, y: view.bounds.height - tableHeight, width: screenWidth, height: tableHeight)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = dataSource
    dataSource.delegate = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
    tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: String(UITableViewHeaderFooterView))
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    dataSource.fetch()
  }
  
  
}

extension HistoryVC: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedSoul = dataSource.soul(forIndex:indexPath.row)
    if selectedSoul == soulPlayer.lastSoul() {
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
    return 30
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 30
  }
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    soulPlayer.reset()
    //stop playing soul
  }
}

extension HistoryVC: HistoryDataSourceDelegate {
  func willFetch() {
    //show loading
  }
  
  func didFetch(success: Bool) {
    if success {
      tableView.reloadData()
    } else {
      //show failure, retry button.
    }
  }
  
}
