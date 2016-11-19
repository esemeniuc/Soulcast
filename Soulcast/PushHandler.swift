//
//  PushHandler.swift
//  Soulcast
//
//  Created by June Kim on 2016-11-19.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation

//singleton for now...
let pushHandler = PushHandler()

class PushHandler {
  var bufferHash: [String:AnyObject]?
  
  func handle(soulHash: [String:AnyObject]) {
    if let appDelegate = app.delegate as? AppDelegate,
      let mainVC = appDelegate.mainCoordinator.mainVC where
      app.applicationState == .Active && mainVC.isViewLoaded() {
      mainVC.receiveRemoteNotification(soulHash)
    } else {
      bufferHash = soulHash
    }
    //DEBUG
    //        let soulObject = Soul.fromHash(soulHash)
    //        let alert = UIAlertController(title: "options", message: String(soulObject), preferredStyle: .Alert)
    //        self.window!.rootViewController!.presentViewController(alert, animated: true, completion: {
    //          //
    //        })

  }
  
  func activate() {
    if let hash = bufferHash {
      bufferHash = nil
      handle(hash)
    }
    //TODO: check soloQueue?
    /*
     if !soloQueue.isEmpty {
     delegate?.presentIncomingVC()
     }
     */
  }
  
}
