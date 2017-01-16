

import UIKit

let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

extension UIViewController {
  func addChildVC(_ vc: UIViewController) {
    addChildViewController(vc)
    view.addSubview(vc.view)
    vc.didMove(toParentViewController: vc)
  }
  func removeChildVC(_ vc: UIViewController) {
    vc.willMove(toParentViewController: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParentViewController()
  }
  func name() -> String {
    return  NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
  }
  func navigationBarHeight() -> CGFloat {
    if let navController = navigationController {
      return navController.navigationBar.height
    } else {
      return 0
    }
  }
  func put(_ aSubview:UIView, inside thisView:UIView, onThe position:Position, withPadding padding:CGFloat) {
    view.put(aSubview, inside: thisView, onThe: position, withPadding: padding)
  }
  func put(_ aView:UIView, besideAtThe position:Position, of relativeView:UIView, withSpacing spacing:CGFloat) {
    view.put(aView, atThe: position, of: relativeView, withSpacing: spacing)
  }
  
}


enum Position {
  case left
  case right
  case top
  case bottom
  case topLeft
  case topRight
  case bottomLeft
  case bottomRight
}

protocol PutAware {
  func wasPut()
}

extension UIView { //put
  
  convenience init(width theWidth:CGFloat, height theHeight: CGFloat) {
    self.init()
    self.frame = CGRect(x: 0, y: 0, width: theWidth, height: theHeight)
  }
  
  func put(_ aSubview:UIView, inside thisView:UIView, onThe position:Position, withPadding padding:CGFloat) {
    assert(aSubview.width <= thisView.width &&
      aSubview.height <= thisView.height,
      "The subview is too large to fit inside this view!")
    if position == .left || position == .right {
      assert(aSubview.width + 2  * padding < thisView.width,
        "The padding is too wide!")
    }
    if position == .top || position == .bottom {
      assert(aSubview.height + 2  * padding < thisView.height,
        "The padding is too high!")
    }
    
    if let aLabel = aSubview as? UILabel { aLabel.sizeToFit() }
    var subRect: CGRect = CGRect.zero
    switch position {
    case .left:
      subRect = CGRect(
        x: padding,
        y: thisView.midHeight - aSubview.midHeight,
        width: aSubview.width,
        height: aSubview.height)
    case .right:
      subRect = CGRect(
        x: thisView.width - padding - aSubview.width,
        y: thisView.midHeight - aSubview.midHeight,
        width: aSubview.width,
        height: aSubview.height)
    case .top:
      subRect = CGRect(
        x: thisView.midWidth - aSubview.midWidth,
        y: padding,
        width: aSubview.width,
        height: aSubview.height)
    case .bottom:
      subRect = CGRect(
        x: thisView.midWidth - aSubview.midWidth,
        y: thisView.height - padding - aSubview.height,
        width: aSubview.width,
        height: aSubview.height)
    case .topLeft:
      subRect = CGRect(
        x: padding,
        y: padding,
        width: aSubview.width,
        height: aSubview.height)
    case .topRight:
      subRect = CGRect(
        x: thisView.width - padding - aSubview.width,
        y: padding,
        width: aSubview.width,
        height: aSubview.height)
    case .bottomLeft:
      subRect = CGRect(
        x: padding,
        y: thisView.height - padding - aSubview.height,
        width: aSubview.width,
        height: aSubview.height)
    case .bottomRight:
      subRect = CGRect(
        x: thisView.width - padding - aSubview.width,
        y: thisView.height - padding - aSubview.height,
        width: aSubview.width,
        height: aSubview.height)
      
    }
    aSubview.frame = subRect
    if aSubview.superview != thisView{
      thisView.addSubview(aSubview)
    }
    (aSubview as? PutAware)?.wasPut()
  }
  
  func put(_ aView:UIView, atThe position:Position, of relativeView:UIView, withSpacing spacing:CGFloat) {
    let diagonalSpacing:CGFloat = spacing / sqrt(2.0)
    switch position {
    case .left:
      aView.center = CGPoint(
        x: relativeView.minX - aView.width/2 - spacing,
        y: relativeView.midY)
    case .right:
      aView.center = CGPoint(
        x: relativeView.maxX + aView.width/2 + spacing,
        y: relativeView.midY)
    case .top:
      aView.center = CGPoint(
        x: relativeView.midX,
        y: relativeView.minY - aView.height/2 - spacing)
    case .bottom:
      aView.center = CGPoint(
        x: relativeView.midX,
        y: relativeView.maxY + aView.height/2 + spacing)
    case .topLeft:
      aView.center = CGPoint(
        x: relativeView.minX - aView.width/2 - diagonalSpacing,
        y: relativeView.minY - aView.height/2 - diagonalSpacing)
    case .topRight:
      aView.center = CGPoint(
        x: relativeView.maxX + aView.width/2 + diagonalSpacing,
        y: relativeView.minY - aView.height/2 - diagonalSpacing)
    case .bottomLeft:
      aView.center = CGPoint(
        x: relativeView.minX - aView.width/2 - diagonalSpacing,
        y: relativeView.maxY + aView.height/2 + diagonalSpacing)
    case .bottomRight:
      aView.center = CGPoint(
        x: relativeView.maxX + aView.width/2 + diagonalSpacing,
        y: relativeView.maxY + aView.height/2 + diagonalSpacing)
      
    }
    if let relativeSuperview =  relativeView.superview {
      relativeSuperview.addSubview(aView)
    }
    (aView as? PutAware)?.wasPut()
  }
  
  func resize(toWidth width:CGFloat, toHeight height:CGFloat) {
    frame = CGRect(x: minX, y: minY, width: width, height: height)
    (self as? PutAware)?.wasPut()
  }
  
  func reposition(toX newX:CGFloat, toY newY:CGFloat) {
    frame = CGRect(x: newX, y: newY, width: width, height: height)
    (self as? PutAware)?.wasPut()
  }
  
  func shift(toRight deltaX:CGFloat, toBottom deltaY:CGFloat) {
    frame = CGRect(x: minX + deltaX, y: minY + deltaY, width: width, height: height)
    (self as? PutAware)?.wasPut()
  }
  
  var width: CGFloat {  return frame.width  }
  var height: CGFloat { return frame.height }
  var minX: CGFloat { return frame.minX }
  var minY: CGFloat { return frame.minY }
  var midX: CGFloat { return frame.midX }
  var midY: CGFloat { return frame.midY }
  var midWidth: CGFloat { return frame.width/2 }
  var midHeight: CGFloat { return frame.height/2 }
  var maxX: CGFloat { return frame.maxX }
  var maxY: CGFloat { return frame.maxY }
  
}

enum FontStyle: String {
  case Regular = "Regular"
  case DemiBold = "DemiBold"
  case Medium = "Medium"
}

func brandFont(_ style: FontStyle? = .DemiBold, size:CGFloat? = 16) -> UIFont {
  return UIFont(name: "AvenirNext-" + style!.rawValue, size: size!)!
}

func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func imageFromUrl(_ url:URL) -> UIImage {
  let data = try? Data(contentsOf: url)
  return UIImage(data: data!)!
}

extension UIView {
  
  func animate(to theFrame: CGRect, completion: @escaping () -> () = {}) {
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      self.frame = theFrame
      }, completion: { (finished:Bool) -> Void in
        completion()
    }) 
    
  }
  
  func addShadow() {
    layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    layer.shadowOffset = CGSize.zero
    layer.shadowOpacity = 1
    layer.shadowRadius = 7
  }
  
  func addThinShadow() {
    layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    layer.shadowOffset = CGSize.zero
    layer.shadowOpacity = 1
    layer.shadowRadius = 1
  }
  
}
