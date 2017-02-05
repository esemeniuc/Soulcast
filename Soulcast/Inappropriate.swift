

import Foundation
import UIKit

struct Inappropriate {
  
  enum ReportReason: String {
    case sexual = "sexual"
    case bully = "bully"
    case spam = "spam"
    case other = "other"
  }

  static func VC (
    reportHandler:@escaping(UIAlertAction)->(), blockHandler:@escaping (UIAlertAction)->())
    -> UIAlertController {
      let vc = UIAlertController(
        title: "Inappropriate Soul",
        message: nil,
        preferredStyle: .actionSheet)
      let cancelAction = UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: nil)
      vc.addAction(cancelAction)
      let reportAction = UIAlertAction(
        title: "Report",
        style: .default,
        handler: reportHandler)
      vc.addAction(reportAction)
      let blockAction = UIAlertAction(
        title: "Block",
        style: .destructive,
        handler: blockHandler)
      vc.addAction(blockAction)
      return vc
  }
  
  static func blockConfirmAlert(completion:@escaping ()->()) -> UIAlertController {
    let controller = UIAlertController(
      title: "Block Soul",
      message: "You will no longer hear from the device that casted this soul.",
      preferredStyle: .alert)
    let blockAction = UIAlertAction(
      title: "Block",
      style: .destructive,
      handler: {(action) in
        completion()
    })
    controller.addAction(blockAction)
    controller.addAction(cancelAction())
    return controller
  }
  
  fileprivate static func cancelAction() -> UIAlertAction {
    return UIAlertAction( title: "Cancel", style: .cancel, handler: nil)
  }
  fileprivate static func OKAction() -> UIAlertAction {
    return UIAlertAction( title: "OK", style: .cancel, handler: nil)
  }

  
  static func blockAffirmationAlert() -> UIAlertController {
    let controller = UIAlertController(title: "Blocked!", message: nil, preferredStyle: .alert)
    controller.addAction(OKAction())
    return controller
  }

  static func reportSelectAlert(completion:@escaping (ReportReason)->()) -> UIAlertController {
    let controller = UIAlertController(
      title: "Report Soul",
      message: "What was inappropriate about this message?",
      preferredStyle: .alert)
    
    let sexualAction = UIAlertAction(
      title: "Sexually suggestive",
      style: .destructive) {(action) in
        completion(.sexual)
    }
    controller.addAction(sexualAction)
    
    let bullyAction = UIAlertAction(
      title: "Bullying",
      style: .destructive) { (action) in
        completion(.bully)
    }
    controller.addAction(bullyAction)
    
    let spamAction = UIAlertAction(
      title: "Spam",
      style: .default) { (action) in
        completion(.spam)
    }
    controller.addAction(spamAction)
    
    let otherAction = UIAlertAction(
      title: "Other",
      style: .default) { (action) in
        completion(.other)
    }
    controller.addAction(otherAction)
    
    controller.addAction(cancelAction())
    return controller
  }
  static func reportAffirmationAlert() -> UIAlertController {
    let controller = UIAlertController(title: "Reported!", message: nil, preferredStyle: .alert)
    controller.addAction(OKAction())
    return controller
  }

}




