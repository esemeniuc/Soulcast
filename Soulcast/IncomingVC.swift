

import Foundation
import UIKit

//launches when a soul is caught
class IncomingVC: UIViewController {
  var incomingCatcher: SoulCatcher? {
    didSet{
      incomingCatcher!.delegate = self
    }
  }
  
  override func viewDidLoad() {
    //
  }
  
  
  
}

extension IncomingVC: SoulCatcherDelegate {
  func soulDidStartToDownload(soul:Soul) {
    
  }
  func soulIsDownloading(progress:Float) {
    
  }
  func soulDidFinishDownloading(soul:Soul) {
    
  }
  func soulDidFailToDownload() {
    
  }
}