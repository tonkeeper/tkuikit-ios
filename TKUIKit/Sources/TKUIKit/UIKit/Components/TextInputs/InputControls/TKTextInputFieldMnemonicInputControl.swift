import UIKit

public final class TKTextInputFieldMnemonicInputControl: UIView, TKTextInputFieldInputControl {
  
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
  
  public var indexNumber = 0 {
    didSet {
      indexNumberLabel.text = "\(indexNumber):"
    }
  }
  
  private let inputControl: TKTextInputFieldTextFieldInputControl
  private let indexNumberLabel: UILabel = {
    let label = UILabel()
    label.font = TKTextStyle.body1.font
    label.textColor = .Text.secondary
    label.textAlignment = .right
    label.numberOfLines = 1
    label.isUserInteractionEnabled = false
    return label
  }()
  
  init(inputControl: TKTextInputFieldTextFieldInputControl) {
    self.inputControl = inputControl
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

private extension TKTextInputFieldMnemonicInputControl {
  func setup() {
    addSubview(inputControl)
    addSubview(indexNumberLabel)

    setupTextInputViewEvents()
    setupConstraints()
  }
  
  func setupTextInputViewEvents() {
    inputControl.didEditText = { [weak self] text in
      self?.didEditText?(text)
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
    inputControl.shouldReturn = { [weak self] in
      return (self?.shouldReturn?() ?? true)
    }
  }
  
  func setupConstraints() {
    inputControl.translatesAutoresizingMaskIntoConstraints = false
    indexNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    
    indexNumberLabel.setContentHuggingPriority(.required, for: .horizontal)
    indexNumberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    NSLayoutConstraint.activate([
      indexNumberLabel.leftAnchor.constraint(equalTo: leftAnchor),
      indexNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      indexNumberLabel.widthAnchor.constraint(equalToConstant: 28),
      
      inputControl.heightAnchor.constraint(equalToConstant: 32),
      inputControl.topAnchor.constraint(equalTo: topAnchor),
      inputControl.leftAnchor.constraint(equalTo: indexNumberLabel.rightAnchor, constant: .indexLabelRightPadding),
      inputControl.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputControl.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}

private extension CGFloat {
  static let indexLabelLeftPadding: CGFloat = 10
  static let indexLabelRightPadding: CGFloat = 12
}
