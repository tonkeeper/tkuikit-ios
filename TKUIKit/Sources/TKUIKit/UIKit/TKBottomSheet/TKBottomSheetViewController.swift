import UIKit

public final class TKBottomSheetViewController: UIViewController {
  
  lazy var bottomSheetTransitioningDelegate = TKBottomSheetTransitioningDelegate(
    contentViewController: contentViewController,
    bottomSheetViewController: self)
  
  public override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
    get { bottomSheetTransitioningDelegate }
    set { }
  }

  public override var modalPresentationStyle: UIModalPresentationStyle {
    get {
      .custom
    }
    set { }
  }

  var containerHeight: CGFloat = 0 {
    didSet {
      view.setNeedsLayout()
    }
  }
  var contentHeight: CGFloat = 0 {
    didSet {
      view.setNeedsLayout()
    }
  }
  
  let containerView = UIView()
  let headerView = TKBottomSheetHeaderView()
  let contentViewController: TKBottomSheetContentViewController

  public init(contentViewController: TKBottomSheetContentViewController) {
    self.contentViewController = contentViewController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    view = TKPassthroughView()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    
    containerView.backgroundColor = .Background.page
    containerView.layer.cornerRadius = 16
    
    setupHeader()
    
    view.addSubview(containerView)
    containerView.addSubview(headerView)
    
    addChild(contentViewController)
    containerView.addSubview(contentViewController.view)
    contentViewController.didMove(toParent: self)
    
    contentViewController.didUpdateHeight = { [weak self] in
      guard let self = self else { return }
      self.preferredContentSize.width = self.preferredContentSize.width == 1 ? 2 : 1
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    containerView.frame = CGRect(x: 0,
                                 y: view.bounds.height - containerHeight,
                                 width: view.bounds.width,
                                 height: containerHeight)
    
    let headerHeight = headerView.systemLayoutSizeFitting(
      CGSize(width: containerView.bounds.width, height: 0),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel).height
    headerView.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: headerHeight)
    
    contentViewController.view.frame = CGRect(
      x: 0,
      y: headerView.frame.maxY,
      width: containerView.frame.width,
      height: contentHeight)
  }
  
  func setupHeader() {
    headerView.configure(model: contentViewController.headerItem)
    contentViewController.didUpdatePullCardHeaderItem = { [headerView] in
      headerView.configure(model: $0)
    }
    headerView.closeButton.addTapAction { [weak self] in
      self?.bottomSheetTransitioningDelegate.transition.wantsInteractiveStart = false
      self?.dismiss(animated: true)
    }
  }
}
