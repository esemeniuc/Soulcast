import Foundation
import UIKit
import Alamofire

class SwiftJK {
  
}

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height


func doOnce (taskName:String, task:() -> ()) -> (Bool) {
  if NSUserDefaults.standardUserDefaults().valueForKey("doOnce-" + taskName) == nil {
    task()
    NSUserDefaults.standardUserDefaults().setValue(true, forKey: "doOnce-" + taskName)
    return true
  } else {
    return false
  }
}

var debugging = true

func printline(string:String) {
  if debugging {
    print(string)
  }
}

extension UILabel {
  func decorateWhite(fontSize:CGFloat) {
    self.textColor = UIColor.whiteColor()
    self.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    self.shadowOffset = CGSize(width: 1, height: 1)
    self.font = UIFont(name: "Helvetica", size: fontSize)
    self.textAlignment = NSTextAlignment.Center
    
  }
}