//
//  ZoomTransitionAnimationController.swift
//  Soulcast
//
//  Created by June Kim on 2017-03-19.
//  Copyright © 2017 Soulcast-team. All rights reserved.
//

import UIKit

class ZoomTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

  var originFrame = CGRect.zero
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.35
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true),
      let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else { return }

    let initialFrame = originFrame
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
    if toVC is HistoryVC {
      let containerView = transitionContext.containerView
      containerView.addSubview(toVC.view)
      containerView.addSubview(toSnapshot)
      toVC.view.isHidden = true
      toSnapshot.frame = initialFrame
      UIView.animate(
        withDuration: transitionDuration(using:transitionContext),
        animations: {
          //TODO: zoom
          toSnapshot.frame = finalFrame
      }) { completed in
        //
        toVC.view.isHidden = false
        toSnapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    } else {
      let containerView = transitionContext.containerView
      containerView.addSubview(toVC.view)
      containerView.addSubview(fromSnapshot)

      fromVC.view.isHidden = true
      fromSnapshot.frame = finalFrame
      UIView.animate(
        withDuration: transitionDuration(using:transitionContext),
        animations: {
          //TODO: zoom
          fromSnapshot.frame = initialFrame
      }) { completed in
        //
        fromVC.view.isHidden = false
        fromSnapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }

    }
    
  }
  
}
