import UIKit

public final class TKPaddingContainerView: UIView {
  
  public var padding: UIEdgeInsets = .zero {
    didSet {
      stackViewTopAnchor.constant = padding.top
      stackViewLeftAnchor.constant = padding.left
      stackViewBottomAnchor.constant = -padding.bottom
      stackViewRightAnchor.constant = -padding.right
    }
  }
  
  public var spacing: CGFloat = 0 {
    didSet {
      stackView.spacing = spacing
    }
  }
  
  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    return stackView
  }()
  
  private lazy var stackViewTopAnchor: NSLayoutConstraint = {
    stackView.topAnchor.constraint(equalTo: topAnchor)
  }()
  private lazy var stackViewLeftAnchor: NSLayoutConstraint = {
    stackView.leftAnchor.constraint(equalTo: leftAnchor)
  }()
  private lazy var stackViewRightAnchor: NSLayoutConstraint = {
    stackView.rightAnchor.constraint(equalTo: rightAnchor)
  }()
  private lazy var stackViewBottomAnchor: NSLayoutConstraint = {
    stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setViews(_ views: [UIView]) {
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    views.forEach { stackView.addArrangedSubview($0) }
  }
}

private extension TKPaddingContainerView {
  func setup() {
    addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackViewTopAnchor,
      stackViewLeftAnchor,
      stackViewBottomAnchor,
      stackViewRightAnchor
    ])
  }
}

public extension TKPaddingContainerView {
  static var buttonsContainerPadding: UIEdgeInsets {
    UIEdgeInsets(top: 16, left: 32, bottom: 32, right: 32)
  }
  static var buttonsContainerSpacing: CGFloat {
    16
  }
}
