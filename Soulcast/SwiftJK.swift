import Foundation
import UIKit
import Alamofire

class SwiftJK {
  
}

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

let HelveticaNeueLight = "HelveticaNeue-Light"

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

extension UIView {
  func debugColors() {
    func randomColor() -> UIColor {
      func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
      }
      return UIColor(
        red: randomCGFloat(),
        green: randomCGFloat(),
        blue: randomCGFloat(),
        alpha: 0.7)
    }
    
    for eachSubview in subviews {
      eachSubview.backgroundColor = randomColor()
      eachSubview.debugColors()
    }
  }
}

extension UIViewController {
  func debugColors() {
    view.debugColors()
  }
  func isActiveOnScreen() -> Bool{
    return isViewLoaded() && view.window != nil
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