import UIKit

public final class TKTextInputFieldPlaceholderInputControl: UIView, TKTextInputFieldInputControl {
  
  // MARK: - TKTextInputFieldInputControl
  
  public var didEditText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  public var shouldPaste: ((String) -> Bool)?
  public var shouldReturn: (() -> Bool)?
  public var text: String {
    get {
      inputControl.text
    }
    set {
      updatePlaceholderState(inputText: newValue)
      inputControl.text = newValue
    }
  }
  
  public var accessoryView: UIView? {
    get { inputControl.accessoryView }
    set { inputControl.accessoryView = newValue }
  }
  
  public func setState(_ state: TKTextInputFieldState) {
    inputControl.setState(state)
  }
  
  public var placeholder = "" {
    didSet {
      placeholderLabel.text = placeholder
    }
  }
  
  private let inputControl: TKTextInputFieldInputControl
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
  
  private lazy var placeholderTopConstraint: NSLayoutConstraint = {
    placeholderLabel
      .topAnchor
      .constraint(equalTo: inputControl.topAnchor, constant: .placeholderTopMargin)
  }()
  
  public init(inputControl: TKTextInputFieldInputControl) {
    self.inputControl = inputControl
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    placeholderLabel.layoutIfNeeded()
    placeholderLabel.frame.origin.x = 0
  }
  
  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    return inputControl.becomeFirstResponder()
  }
  
  @discardableResult
  public override func resignFirstResponder() -> Bool {
    return inputControl.resignFirstResponder()
  }
  
  public override var isFirstResponder: Bool {
    inputControl.isFirstResponder
  }
}

private extension TKTextInputFieldPlaceholderInputControl {
  func setup() {
    addSubview(inputControl)
    addSubview(placeholderLabel)
    
    setupTextInputViewEvents()
    setupConstraints()
  }
  
  func setupTextInputViewEvents() {
    inputControl.didEditText = { [weak self] text in
      self?.didEditText?(text)
      self?.updatePlaceholderState(inputText: text)
    }
    inputControl.didBeginEditing = { [weak self] in
      self?.didBeginEditing?()
    }
    inputControl.didEndEditing = { [weak self] in
      self?.didEndEditing?()
    }
    inputControl.shouldPaste = { [weak self] text in
      return (self?.shouldPaste?(text) ?? true)
    }
  }
  
  func setupConstraints() {
    inputControl.translatesAutoresizingMaskIntoConstraints = false
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      inputControl.topAnchor.constraint(equalTo: topAnchor),
      inputControl.leftAnchor.constraint(equalTo: leftAnchor),
      inputControl.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputControl.rightAnchor.constraint(equalTo: rightAnchor),
      
      placeholderTopConstraint
    ])
  }
  
  func updatePlaceholderState(inputText: String) {
    self.layoutIfNeeded()
    let placeholderTransform: CGAffineTransform
    let inputViewTransform: CGAffineTransform
    if inputText.isEmpty {
      placeholderTransform = .identity
      inputViewTransform = .identity
      placeholderTopConstraint.constant = .placeholderTopMargin
    } else {
      placeholderTransform = .init(scaleX: .placeholderScale, y: .placeholderScale)
      inputViewTransform = .init(translationX: 0, y: .inputYOffset)
      placeholderTopConstraint.constant = -3
    }
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.placeholderLabel.transform = placeholderTransform
      self.inputControl.transform = inputViewTransform
      self.placeholderLabel.layoutIfNeeded()
      self.layoutIfNeeded()
    }
  }
}

private extension CGFloat {
  static let placeholderScale: CGFloat = 0.75
  static let placeholderTopMargin: CGFloat = 10
  static let inputYOffset: CGFloat = 7
}
