import UIKit

public final class TKTextInputFieldPasswordInputControl: UIView, TKTextInputFieldInputControl {
  
  // MARK: - TKTextInputFieldInputControl
  
  public var didEditText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  public var shouldPaste: ((String) -> Bool)?
  public var text: String {
    get {
      inputControl.text
    }
    set {
      inputControl.text = newValue
    }
  }
  
  public func setState(_ state: TKTextInputFieldState) {
    self.state = state
    inputControl.setState(state)
    inputControl.textField.attributedText = getAttributedPasswordHashString(
      string: inputControl.textField.text ?? "",
      state: state
    )
    switch state {
    case .active, .inactive:
      inputControl.textField.tintColor = state.tintColor
    case .error:
      inputControl.textField.tintColor = .Accent.red
    }
  }
  
  private var state: TKTextInputFieldState = .inactive
  private var passwordText = "" {
    didSet {
      didEditText?(passwordText)
    }
  }
  
  private let inputControl: TKTextInputFieldTextFieldInputControl
  
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

private extension TKTextInputFieldPasswordInputControl {
  func setup() {
    addSubview(inputControl)

    inputControl.textField.textAlignment = .center
    inputControl.textField.delegate = self
    
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
  }
  
  func setupConstraints() {
    inputControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      inputControl.topAnchor.constraint(equalTo: topAnchor),
      inputControl.leftAnchor.constraint(equalTo: leftAnchor),
      inputControl.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputControl.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
  
  func getHashPasswordString() -> NSAttributedString {
    let hashPassword = (0..<passwordText.count).map { _ in "\u{25CF}" }.joined()
    return getAttributedPasswordHashString(
      string: hashPassword,
      state: state
    )
  }
  
  func getAttributedPasswordHashString(string: String,
                                       state: TKTextInputFieldState) -> NSAttributedString {
    let color: UIColor
    switch state {
    case .active, .inactive:
      color = .Icon.secondary
    case .error:
      color = .Accent.red
    }
    return NSAttributedString(
      string: string,
      attributes: [
        .kern: 3,
        .foregroundColor: color,
        .font: TKTextStyle.h2.font
      ])
  }
}

extension TKTextInputFieldPasswordInputControl: UITextFieldDelegate {
  public func textField(_ textField: UITextField,
                        shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
    guard let stringRange = Range(range, in: passwordText) else {
      return false
    }
    let oldLength = passwordText.count
    passwordText.replaceSubrange(stringRange, with: string)
    let newLength = passwordText.count
    
    var newPosition: UITextPosition?
    if let selectedRange = textField.selectedTextRange {
      let lengthDiff = newLength - oldLength
      newPosition = textField.position(from: selectedRange.start, offset: lengthDiff)
    }
    
    textField.attributedText = getHashPasswordString()
    
    if let newPosition = newPosition {
      textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
    return false
  }
}

