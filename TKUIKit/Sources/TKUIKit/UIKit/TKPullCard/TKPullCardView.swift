import UIKit

public final class TKPullCardView: TKPassthroughView {
 
  var maximumContentHeight: CGFloat {
    bounds.height
    - safeAreaInsets.top - safeAreaInsets.bottom
    - headerView.bounds.height
  }
  
  var contentHeight: CGFloat = 0 {
    didSet {
      contentContainerHeightConstraint.constant = contentHeight
    }
  }
  
  var dragOffset: CGFloat = 0 {
    didSet {
      switch dragOffset {
      case ..<0:
        contentContainerBottomConstraint.constant = dragOffset
      case 0:
        contentContainerBottomConstraint.constant = 0
        mainContainerBottomConstraint.constant = 0
      case 0...:
        mainContainerBottomConstraint.constant = dragOffset
      default: break
      }
    }
  }
  
  let contentContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .Background.page
    return view
  }()
  
  let mainContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .Background.page
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.cornerRadius = .cornerRadius
    view.layer.masksToBounds = true
    return view
  }()
  
  let headerView = TKPullCardHeaderView()
  
  private lazy var contentContainerHeightConstraint: NSLayoutConstraint = {
    contentContainer.heightAnchor.constraint(equalToConstant: 0)
  }()
  private lazy var contentContainerBottomConstraint: NSLayoutConstraint = {
    contentContainer.bottomAnchor.constraint(equalTo: mainContainer.safeAreaLayoutGuide.bottomAnchor)
  }()
  private lazy var mainContainerBottomConstraint: NSLayoutConstraint = {
    mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setContentView(_ view: UIView) {
    contentContainer.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
      view.leftAnchor.constraint(equalTo: contentContainer.leftAnchor),
      view.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
      view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
    ])
  }
  
  func removeContentView() {
    contentContainer.subviews.forEach { $0.removeFromSuperview() }
  }
}

private extension TKPullCardView {
  func setup() {
    addSubview(mainContainer)
    mainContainer.addSubview(headerView)
    mainContainer.addSubview(contentContainer)
    
    mainContainer.translatesAutoresizingMaskIntoConstraints = false
    contentContainer.translatesAutoresizingMaskIntoConstraints = false
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mainContainerBottomConstraint,
      mainContainer.leftAnchor.constraint(equalTo: leftAnchor),
      mainContainer.rightAnchor.constraint(equalTo: rightAnchor),
      
      headerView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
      headerView.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
      
      contentContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      contentContainer.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
      contentContainer.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
      contentContainerBottomConstraint,
      contentContainerHeightConstraint
    ])
  }
}

private extension CGFloat {
  static let cornerRadius: CGFloat = 16
}
