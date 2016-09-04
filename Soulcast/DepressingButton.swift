
import UIKit

///An extension to allow a depressing animation when touched down
extension UIButton {
  func setupDepression() {
    addTarget(self, action: #selector(UIButton.didTouchDown(_:)), forControlEvents: .TouchDown)
    addTarget(self, action: #selector(UIButton.didTouchDragExit(_:)), forControlEvents: .TouchDragExit)
    addTarget(self, action: #selector(UIButton.didTouchUp(_:)), forControlEvents: .TouchUpInside)
  }
  
  func didTouchDown(button:UIButton) {
    UIView.animateWithDuration(0.07){
      self.transform = CGAffineTransformMakeScale(0.98, 0.98)
    }
  }
  
  func didTouchDragExit(button:UIButton) {
    UIView.animateWithDuration(0.07){
      self.transform = CGAffineTransformMakeScale(1, 1)
    }
  }
  
  func didTouchUp(button:UIButton) {
    UIView.animateWithDuration(0.07){
      self.transform = CGAffineTransformMakeScale(1, 1)
    }
  }
  
  @objc override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    let exitExtension: CGFloat = 5
    let outerBounds: CGRect = CGRectInset(self.bounds, -exitExtension, -exitExtension)
    let touchOutside: Bool = !CGRectContainsPoint(outerBounds, touch.locationInView(self))
    if touchOutside {
      let previousTouchInside = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))
      if previousTouchInside {
        sendActionsForControlEvents(.TouchDragExit)
        return false
      } else {
        sendActionsForControlEvents(.TouchDragOutside)
        return false
      }
    }
    return super.continueTrackingWithTouch(touch, withEvent: event)
  }
  
}