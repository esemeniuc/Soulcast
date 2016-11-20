//
//  HistoryDataSource.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryDataSourceDelegate {
  func willFetch()
  func didFetch(success:Bool)
}

class HistoryDataSource: NSObject {
  private var souls = [Soul]()
  var delegate: HistoryDataSourceDelegate?
  func fetch() {
    delegate?.willFetch()
    MockServerFacade.getHistory({ souls in
      self.souls = souls
      
      self.delegate?.didFetch(true)
      }, failure:  { failureCode in
        self.delegate?.didFetch(false)
    })
  }
  func soul(forIndex index:Int) -> Soul? {
    guard index < souls.count else {
      return nil
    }
    return souls[index]
  }
}

extension HistoryDataSource: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return souls.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "History"
  }
  
  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return ""
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .Default, reuseIdentifier: String(UITableViewCell))
    cell.textLabel?.text = "Some soul"
    return cell
  }
}
