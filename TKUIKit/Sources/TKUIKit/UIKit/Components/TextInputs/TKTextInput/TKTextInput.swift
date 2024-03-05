import UIKit
import SnapKit

public protocol TKTextInputInputView: UIView {}

open class TKTextInput<TextInputView: TKTextInputInputView>: UIControl {
  
  public var rightItemsViews = [UIView]() {
    didSet {
      didSetRightItemsViews()
    }
  }
  
  public var didEditText: ((String?) -> Void)?
  
  public let backgroundView = TKTextInputBackgroundView()
  public let textInputView = TextInputView()
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = TKTextStyle.body1.font
    label.textColor = .Text.secondary
    label.textAlignment = .left
    label.numberOfLines = 1
    label.isUserInteractionEnabled = false
    label.layer.anchorPoint = .init(x: 0, y: 0.5)
    return label
  }()
  private let rightItemsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  
  public var text: String = "" {
    didSet {
      didUpdateText()
    }
  }

  public var placeholder: String? {
    get { placeholderLabel.text }
    set {
      placeholderLabel.text = newValue
      setNeedsLayout()
    }
  }
  
  public var isValid = true {
    didSet {
      updateState()
    }
  }
  
  public var isHighlightable: Bool = false
  
  public var textInputState: TKTextInputFieldState = .inactive {
    didSet {
      UIView.animate(withDuration: 0.2) {
        self.didUpdateState()
      }
    }
  }
  
  open override var isHighlighted: Bool {
    didSet {
      guard isHighlightable else { return }
      switch textInputState {
      case .inactive:
        backgroundView.isHighlighted = isHighlighted
      default:
        backgroundView.isHighlighted = false
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 64)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    placeholderLabel.sizeToFit()
    if text.isEmpty {
      placeholderLabel.frame.origin = CGPoint(x: 16, y: bounds.height/2 - placeholderLabel.frame.height/2)
    } else {
      placeholderLabel.frame.origin = CGPoint(x: 16, y: 12)
    }
  }
  
  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return textInputView.becomeFirstResponder()
  }
  
  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return textInputView.resignFirstResponder()
  }
  
  func updateState() {
    let isFirstResponder = textInputView.isFirstResponder
    textInputView.isUserInteractionEnabled = isFirstResponder
    switch (isFirstResponder, isValid) {
    case (false, true):
      textInputState = .inactive
    case (true, true):
      textInputState = .active
    case (false, false):
      textInputState = .error
    case (true, false):
      textInputState = .error
    }
  }
  
  func didUpdateState() {
    backgroundView.state = textInputState
  }
}

private extension TKTextInput {
  func setup() {
    backgroundView.isUserInteractionEnabled = false
    
    addSubview(backgroundView)
    addSubview(textInputView)
    addSubview(placeholderLabel)
    addSubview(rightItemsStackView)
    
    backgroundView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
    
    textInputView.snp.makeConstraints { make in
      make.edges.equalTo(self).inset(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
    
    rightItemsStackView.snp.makeConstraints { make in
      make.centerY.equalTo(self)
      make.right.equalTo(self).inset(14)
    }
    
    addAction(UIAction(handler: { [weak self] _ in
      self?.textInputView.becomeFirstResponder()
    }), for: .touchUpInside)
  }
  
  func didUpdateText() {
    layoutIfNeeded()
    textInputView.snp.remakeConstraints { make in
      if text.isEmpty {
        make.edges.equalTo(self).inset(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
      } else {
        make.edges.equalTo(self).inset(UIEdgeInsets(top: 28, left: 16, bottom: 12, right: 16))
      }
    }
    let placeholderTransform: CGAffineTransform
    let rightItemsStackViewAlpha: CGFloat
    if text.isEmpty {
      placeholderTransform = .identity
      rightItemsStackViewAlpha = 1
    } else {
      placeholderTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
      rightItemsStackViewAlpha = 0
    }
    
    self.rightItemsStackView.alpha = rightItemsStackViewAlpha
    UIView.animate(withDuration: 0.2) {
      self.placeholderLabel.transform = placeholderTransform
      self.layoutIfNeeded()
    }
  }
  
  func didSetRightItemsViews() {
    rightItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    rightItemsViews.forEach { rightItemsStackView.addArrangedSubview($0) }
  }
}
