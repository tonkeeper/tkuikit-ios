import UIKit

class TKBottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  let contentViewController: TKBottomSheetContentViewController
  weak var bottomSheetViewController: TKBottomSheetViewController?
  let transition = TKBottomSheetTransition()
  
  init(contentViewController: TKBottomSheetContentViewController,
       bottomSheetViewController: TKBottomSheetViewController) {
    self.contentViewController = contentViewController
    self.bottomSheetViewController = bottomSheetViewController
  }
  
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = true
    transition.wantsInteractiveStart = false
    return transition
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.isPresenting = false
    return transition
  }


  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    transition.isPresenting = false
    return transition
  }

  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
    TKBottomSheetPresentationController(
      contentViewController: contentViewController,
      bottomSheeetViewController: bottomSheetViewController,
      transition: transition,
      presentedViewController: presented,
      presenting: presenting)
  }
}
