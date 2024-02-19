import UIKit

public class TKButton: UIControl, ConfigurableView {
  
  public enum State {
    case normal
    case highlighted
    case disabled
    case selected
  }
  
  public var backgroundColors: [State: UIColor] = [.normal: .Text.primary] {
    didSet {
      updateBackground()
    }
  }
  public var foregroundColors: [State: UIColor] = [.normal: .clear] {
    didSet {
      updateForeground()
    }
  }
  public var contentPadding: UIEdgeInsets = .zero {
    didSet {
      didUpdateContentPadding()
    }
  }
  public var cornerRadius: CGFloat = 0 {
    didSet {
      didUpdateCornerRadius()
    }
  }
  public var tapAreaInsets: UIEdgeInsets = .zero
  public var textStyle: TKTextStyle = .label1 {
    didSet {
      titleLabel.font = textStyle.font
    }
  }
  
  public override var isHighlighted: Bool {
    didSet {
      didUpdateState()
    }
  }
  
  public override var isEnabled: Bool {
    didSet {
      didUpdateState()
    }
  }
  
  public override var isSelected: Bool {
    didSet {
      didUpdateState()
    }
  }
  
  public private(set) var buttonState: State = .normal
  
  private let contentStackView = UIStackView()
  private let titleLabel = UILabel()
  private let iconImageView = UIImageView()
  
  private lazy var contentTopConstraint: NSLayoutConstraint = {
    contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding.top)
  }()
  private lazy var contentLeftConstraint: NSLayoutConstraint = {
    contentStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: contentPadding.left)
  }()
  private lazy var contentBottomConstraint: NSLayoutConstraint = {
    contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: contentPadding.bottom)
      .withPriority(.defaultHigh)
  }()
  private lazy var contentRightConstraint: NSLayoutConstraint = {
    contentStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: contentPadding.right)
      .withPriority(.defaultHigh)
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public struct Model: Hashable {
    public struct Icon: Hashable {
      public let icon: UIImage
      public let position: IconPosition
      public init(icon: UIImage, position: IconPosition) {
        self.icon = icon
        self.position = position
      }
    }
    public enum IconPosition: Hashable {
      case left
      case right
    }
    public let title: String?
    public let icon: Icon?
    
    public init(title: String? = nil, 
                icon: Icon? = nil) {
      self.title = title
      self.icon = icon
    }
  }
  
  public func configure(model: Model) {
    titleLabel.text = model.title
    contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    if model.title != nil {
      contentStackView.addArrangedSubview(titleLabel)
    }
    if let icon = model.icon {
      switch icon.position {
      case .left:
        contentStackView.insertArrangedSubview(iconImageView, at: 0)
      case .right:
        contentStackView.addArrangedSubview(iconImageView)
      }
      iconImageView.image = icon.icon
    }
  }
  
  public func setTapAction(_ action: @escaping () -> Void) {
    enumerateEventHandlers { action, targetAction, event, stop in
      if let action = action {
        removeAction(action, for: event)
      }
    }
    
    addAction(UIAction(handler: { _ in
      action()
    }), for: .touchUpInside)
  }
}

private extension TKButton {
  func setup() {
    contentStackView.isUserInteractionEnabled = false
    
    addSubview(contentStackView)
    
    contentStackView.addArrangedSubview(titleLabel)
    
    updateBackground()
    updateForeground()
    
    setupConstraints()
  }
  
  func setupConstraints() {
    setContentHuggingPriority(.required, for: .horizontal)
    contentStackView.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentTopConstraint,
      contentLeftConstraint,
      contentRightConstraint,
      contentBottomConstraint
    ])
  }
  
  func updateBackground() {
    let defaultColor = backgroundColors[.normal]
    backgroundColor = backgroundColors[buttonState] ?? defaultColor
  }
  
  func updateForeground() {
    let defaultColor = foregroundColors[.normal]
    let color: UIColor? = foregroundColors[buttonState] ?? defaultColor
    titleLabel.textColor = color
    iconImageView.tintColor = color
  }
  
  func didUpdateState() {
    switch (isEnabled, isHighlighted, isSelected) {
    case (false, _, _):
      buttonState = .disabled
    case (true, true, _):
      buttonState = .highlighted
    case (true, false, true):
      buttonState = .selected
    case (true, false, false):
      buttonState = .normal
    }
    updateBackground()
    updateForeground()
  }
  
  func didUpdateContentPadding() {
    contentTopConstraint.constant = contentPadding.top
    contentLeftConstraint.constant = contentPadding.left
    contentBottomConstraint.constant = -contentPadding.bottom
    contentRightConstraint.constant = -contentPadding.right
  }
  
  func didUpdateCornerRadius() {
    layer.masksToBounds = cornerRadius > 0
    layer.cornerRadius = cornerRadius
  }
}

extension UIControl.State: Hashable {}
