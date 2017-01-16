
import UIKit

///An extension to allow a depressing animation when touched down
extension UIButton {
  func setupDepression() {
    addTarget(self, action: #selector(UIButton.didTouchDown(_:)), for: .touchDown)
    addTarget(self, action: #selector(UIButton.didTouchDragExit(_:)), for: .touchDragExit)
    addTarget(self, action: #selector(UIButton.didTouchUp(_:)), for: .touchUpInside)
  }
  
  func didTouchDown(_ button:UIButton) {
    UIView.animate(withDuration: 0.07, animations: {
      self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
    })
  }
  
  func didTouchDragExit(_ button:UIButton) {
    UIView.animate(withDuration: 0.07, animations: {
      self.transform = CGAffineTransform(scaleX: 1, y: 1)
    })
  }
  
  func didTouchUp(_ button:UIButton) {
    UIView.animate(withDuration: 0.07, animations: {
      self.transform = CGAffineTransform(scaleX: 1, y: 1)
    })
  }
  
  @objc override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let exitExtension: CGFloat = 5
    let outerBounds: CGRect = self.bounds.insetBy(dx: -exitExtension, dy: -exitExtension)
    let touchOutside: Bool = !outerBounds.contains(touch.location(in: self))
    if touchOutside {
      let previousTouchInside = outerBounds.contains(touch.previousLocation(in: self))
      if previousTouchInside {
        sendActions(for: .touchDragExit)
        return false
      } else {
        sendActions(for: .touchDragOutside)
        return false
      }
    }
    return super.continueTracking(touch, with: event)
  }
  
}
