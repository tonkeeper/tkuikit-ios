import UIKit

public final class TKPullCardViewController: GenericViewViewController<TKPullCardView> {
  public override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
    get { dimmingTransitioningDelegate }
    set {}
  }
  
  public override var modalPresentationStyle: UIModalPresentationStyle {
    get { .custom }
    set {}
  }
  
  private let dimmingTransitioningDelegate = DimmingTransitioningDelegate()
  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer()
    gestureRecognizer.addTarget(self, action: #selector(panGestureHandler(_:)))
    return gestureRecognizer
  }()
  private lazy var scrollController = TKPullCardScrollController()
  
  private var contentHeight: CGFloat = 0 {
    didSet {
      guard contentHeight != oldValue else { return }
      customView.contentHeight = contentHeight
    }
  }
  
  private var scrollableContent: TKPullCardScrollableContent? {
    content as? TKPullCardScrollableContent
  }
  
  private let content: TKPullCardContent
  public init(content: TKPullCardContent) {
    self.content = content
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupContentHeightAlongsideTransition()
  }
}

private extension TKPullCardViewController {
  func setup() {
    setupContent()
    setupGestures()
    setupHeader()
  }
  
  func setupContent() {
    addChild(content)
    customView.setContentView(content.view)
    content.didMove(toParent: self)
    
    scrollController.scrollView = scrollableContent?.scrollView
  }
  
  func setupHeader() {
    customView.headerView.configure(model: content.headerItem)
    content.didUpdatePullCardHeaderItem = { [customView] in
      customView.headerView.configure(model: $0)
    }
    customView.headerView.closeButton.addTapAction { [weak self] in
      self?.dismiss(animated: true)
    }
  }
  
  func setupGestures() {
    customView.addGestureRecognizer(panGestureRecognizer)
    
    setupScrollGesture()
  }
  
  func setupScrollGesture() {
    scrollController.didDrag = { [weak self] offset in
      self?.didDrag(with: max(-.maximumDragOffset, offset * .dragOffsetRatio))
    }
    
    scrollController.didEndDragging = { [weak self] offset, velocity in
      self?.didEndDragging(offset: offset, velocity: velocity)}
  }
  
  func setupContentHeightAlongsideTransition() {
    transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
      self?.setupContentHeight()
    }, completion: { [weak self] _ in
      self?.startContentHeightObservation()
    })
  }
  
  func setupContentHeight() {
    defer {
      panGestureRecognizer.isEnabled = true
    }
    panGestureRecognizer.isEnabled = false
    let contentHeight = content.contentHeight(withWidth: view.bounds.width)
    let maximumContentHeight = customView.maximumContentHeight
    let finalContentHeight = min(contentHeight, maximumContentHeight)
    
    scrollableContent?.scrollView.isScrollEnabled = contentHeight > maximumContentHeight
    
    self.contentHeight = finalContentHeight
  }
  
  func startContentHeightObservation() {
    self.content.didUpdateHeight = { [weak self] in
      self?.setupContentHeight()
      self?.animateContentHeightChange()
    }
  }
  
  func animateContentHeightChange() {
    UIView.animate(
      withDuration: .animationDuration,
      delay: .zero,
      usingSpringWithDamping: .animationSpringDamping,
      initialSpringVelocity: .animationSpringVelocity,
      options: [.curveEaseInOut, .allowUserInteraction]) {
        self.customView.layoutIfNeeded()
      }
  }
  
  @objc
  func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
    let yTranslation = recognizer.translation(in: recognizer.view).y
    let dragOffset = max(-.maximumDragOffset, yTranslation * .dragOffsetRatio)
    switch recognizer.state {
    case .changed:
      didDrag(with: dragOffset)
    case .ended:
      let yVelocity = recognizer.velocity(in: recognizer.view).y
      didEndDragging(offset: dragOffset, velocity: yVelocity)
    case .cancelled, .failed:
      didEndDragging(offset: 0, velocity: 0)
    default:
      break
    }
  }
  
  func didDrag(with offset: CGFloat) {
    customView.dragOffset = offset
  }
  
  func didEndDragging(offset: CGFloat, velocity: CGFloat) {
    let isDismiss = offset >= .dragTreshold || velocity >= .velocityTreshold
    if isDismiss {
      dismiss(animated: true)
    } else {
      customView.dragOffset = 0
      animateContentHeightChange()
    }
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
