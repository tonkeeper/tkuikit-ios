import UIKit

class TKBottomSheetTransition: UIPercentDrivenInteractiveTransition {
  var isPresenting = true
  
  var presentationAnimator: UIViewPropertyAnimator?
  var dismissAnimator: UIViewPropertyAnimator?
}

extension TKBottomSheetTransition: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    .animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    animator(using: transitionContext).startAnimation()
  }
  
  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    animator(using: transitionContext)
  }
  
  func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    if isPresenting {
      if let presentationAnimator = presentationAnimator {
        return presentationAnimator
      } else {
        let presentationAnimator = createPresentationAnimator(using: transitionContext)
        self.presentationAnimator = presentationAnimator
        return presentationAnimator
      }
    } else {
      if let dismissAnimator = dismissAnimator {
        return dismissAnimator
      } else {
        let dismissAnimator = createDismissAnimator(using: transitionContext)
        self.dismissAnimator = dismissAnimator
        return dismissAnimator
      }
    }
  }
  
  func createPresentationAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator {
    guard
      let toViewController = transitionContext.viewController(forKey: .to),
      let toView = transitionContext.view(forKey: .to) else { return UIViewPropertyAnimator() }
    
    let containerView = transitionContext.containerView
    
    let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                          dampingRatio: .animationSpringDamping)
    
    
    toView.frame = transitionContext.finalFrame(for: toViewController)
    toView.frame.origin.y = containerView.frame.maxY
    containerView.addSubview(toView)
    
    animator.addAnimations {
      toView.frame = transitionContext.finalFrame(for: toViewController)
    }
    
    animator.addCompletion { position in
      switch position {
      case .end:
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      default: transitionContext.completeTransition(false)
      }
    }
    return animator
  }
  
  func createDismissAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator {
    guard let fromView = transitionContext.view(forKey: .from) else {
      return UIViewPropertyAnimator()
    }
    
    let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.9)
    
    animator.addAnimations {
      fromView.frame.origin.y = fromView.frame.maxY
    }
    animator.addCompletion { [weak self] position in
      self?.dismissAnimator = nil
      guard case .end = position else {
        transitionContext.completeTransition(false)
        return
      }
      fromView.removeFromSuperview()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    return animator
  }
}

private extension CGFloat {
  static let animationSpringDamping: CGFloat = 0.9
  static let animationSpringVelocity: CGFloat = 0
}

private extension TimeInterval {
  static let animationDuration: TimeInterval = 0.5
}
