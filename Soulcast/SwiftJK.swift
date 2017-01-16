import Foundation
import UIKit
import Alamofire

class SwiftJK {
  
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let HelveticaNeue = "HelveticaNeue"
let HelveticaNeueLight = "HelveticaNeue-Light"
let HelveticaNeueMedium = "HelveticaNeue-Medium"

let offBlue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
let offRed = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)

func doOnce (_ taskName:String, task:() -> ()) -> (Bool) {
  if UserDefaults.standard.value(forKey: "doOnce-" + taskName) == nil {
    task()
    UserDefaults.standard.setValue(true, forKey: "doOnce-" + taskName)
    return true
  } else {
    return false
  }
}

var debugging = true

func printline(_ string:String) {
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
    return isViewLoaded && view.window != nil
  }
}

extension UILabel {
  func decorateWhite(_ fontSize:CGFloat) {
    self.textColor = UIColor.white
    self.shadowColor = UIColor.black.withAlphaComponent(0.3)
    self.shadowOffset = CGSize(width: 1, height: 1)
    self.font = UIFont(name: "Helvetica", size: fontSize)
    self.textAlignment = NSTextAlignment.center
    
  }
}

