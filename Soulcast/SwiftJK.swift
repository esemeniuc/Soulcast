import Foundation
import UIKit
import Alamofire

class SwiftJK {
  
}

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

let HelveticaNeue = "HelveticaNeue"
let HelveticaNeueLight = "HelveticaNeue-Light"
let HelveticaNeueMedium = "HelveticaNeue-Medium"

let offBlue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
let offRed = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)

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

