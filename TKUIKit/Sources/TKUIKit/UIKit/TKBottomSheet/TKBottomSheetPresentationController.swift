import UIKit

class TKBottomSheetPresentationController: UIPresentationController {
  let contentViewController: TKBottomSheetContentViewController
  weak var bottomSheetViewController: TKBottomSheetViewController?
  let transition: TKBottomSheetTransition
  
  let dimmingView = TKBottomSheetDimmingView()
  
  private lazy var tapGesture = UITapGestureRecognizer(
    target: self,
    action: #selector(tapGestureHandler)
  )
  
  private lazy var panGesture = UIPanGestureRecognizer(
    target: self,
    action: #selector(panGestureHandler(_:))
  )
  
  private let scrollController = TKBottomSheetScrollController()
  
  init(contentViewController: TKBottomSheetContentViewController,
       bottomSheeetViewController: TKBottomSheetViewController?,
       transition: TKBottomSheetTransition,
       presentedViewController: UIViewController,
       presenting presentingViewController: UIViewController?) {
    self.contentViewController = contentViewController
    self.bottomSheetViewController = bottomSheeetViewController
    self.transition = transition
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
  }
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    dimmingView.addGestureRecognizer(tapGesture)
    containerView?.addSubview(dimmingView)
    
    presentedView?.addGestureRecognizer(panGesture)
    
    layoutContainer(animated: false)

    dimmingView.prepareForPresentationTransition()
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [dimmingView] _ in
      dimmingView.performPresentationTransition()
    })
  }
  
  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [dimmingView] _ in
      dimmingView.performDismissalTransition()
    })
  }
  
  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    
    dimmingView.frame = containerView?.bounds ?? .zero
  }
  
  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    panGesture.isEnabled = false
    panGesture.isEnabled = true
    
    layoutContainer(animated: true)
    
  }
  
  private func calculateHeights() -> (contentHeight: CGFloat, containerHeight: CGFloat) {
    guard let containerView = containerView else {
      return (0, 0)
    }
    
    let headerHeight = bottomSheetViewController?.headerView.systemLayoutSizeFitting(CGSize(width: containerView.bounds.width, height: 0)).height ?? 0
    
    let contentMaximumHeight = containerView.frame.height
    - containerView.safeAreaInsets.top
    - containerView.safeAreaInsets.bottom
    - headerHeight

    if let scrollableContent = contentViewController as? TKBottomSheetScrollContentViewController {
      scrollableContent.view.frame = containerView.bounds
      scrollableContent.view.setNeedsLayout()
      scrollableContent.view.layoutIfNeeded()

      scrollController.scrollView = scrollableContent.scrollView

      scrollController.didStartDragging = { [weak self] in
        self?.dismiss(interactive: true)
      }

      scrollController.didEndDragging = { [weak self] _, _ in
        self?.handleEndedInteraction(for: .zero)
      }

      scrollController.didDrag = { [weak self] offset in
        self?.updateTransitionProgress(for: CGPoint(x: 0, y: offset))
      }
      
      
      let contentHeight = scrollableContent.scrollView.contentSize.height
      let adjustedHeight = min(contentMaximumHeight, contentHeight)
      
      let containerHeight = containerView.safeAreaInsets.bottom + adjustedHeight + headerHeight
      
      return (adjustedHeight, containerHeight)
    } else {
      let contentHeight = contentViewController.view
        .systemLayoutSizeFitting(CGSize(width: containerView.bounds.width, height: 0),
                                 withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
      let adjustedHeight = min(contentMaximumHeight, contentHeight)
      let containerHeight = containerView.safeAreaInsets.bottom + adjustedHeight + headerHeight
      
      return (adjustedHeight, containerHeight)
    }
  }
  
  private func layoutContainer(animated: Bool) {
    let (contentHeight, containerHeight) = calculateHeights()
    
    bottomSheetViewController?.contentHeight = contentHeight
    bottomSheetViewController?.view.layoutIfNeeded()
    
    bottomSheetViewController?.containerHeight = containerHeight
    if animated {
      animate {
        self.bottomSheetViewController?.view.layoutIfNeeded()
      }
    } else {
      self.bottomSheetViewController?.view.layoutIfNeeded()
    }
  }
  
  private func animate(animation: @escaping () -> Void) {
    UIView.animate(
      withDuration: .animationDuration,
      delay: .zero,
      usingSpringWithDamping: .animationSpringDamping,
      initialSpringVelocity: .animationSpringVelocity,
      options: [.curveEaseInOut, .allowUserInteraction]) {
        animation()
      }
  }
  
  @objc private func tapGestureHandler() {
    dismiss(interactive: false)
  }
  
  @objc private func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
    guard let bottomSheetViewController = bottomSheetViewController else { return }
    switch recognizer.state {
    case .began:
      dismiss(interactive: true)
    case .changed:
      let translation = recognizer.translation(in: bottomSheetViewController.view)
      updateTransitionProgress(for: translation)
    case .ended:
      let translation = recognizer.translation(in: bottomSheetViewController.view)
      handleEndedInteraction(for: translation)
    case .cancelled, .failed:
      handleFailedInteraction()
    default:
      break
    }
  }
  
  func dismiss(interactive: Bool) {
    transition.wantsInteractiveStart = interactive
    presentedViewController.dismiss(animated: true)
  }
  
  private func updateTransitionProgress(for translation: CGPoint) {
    guard let bottomSheetViewController = bottomSheetViewController else { return }
    let adjustedHeight = bottomSheetViewController.view.frame.height - translation.y
    let progress = 1 - (adjustedHeight / bottomSheetViewController.view.frame.height)
    transition.update(progress)
  }
  
  private func handleEndedInteraction(for translation: CGPoint) {
    guard let bottomSheetViewController = bottomSheetViewController else { return }
    if translation.y > bottomSheetViewController.containerHeight * 0.3 {
      transition.finish()
    } else {
      transition.cancel()
    }
  }
  
  private func handleFailedInteraction() {
    transition.cancel()
  }
}


private extension CGFloat {
  static let maximumDragOffset: CGFloat = 20
  static let dragOffsetRatio: CGFloat = 1/2
  static let dragTreshold: CGFloat = 50
  static let velocityTreshold: CGFloat = 1500
  static let animationSpringDamping: CGFloat = 2
  static let animationSpringVelocity: CGFloat = 0
}

private extension TimeInterval {
  static let animationDuration: TimeInterval = 0.4
}
