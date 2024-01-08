import UIKit

public final class TKTextInputFieldTextFieldInputControl: UIView, TKTextInputFieldInputControl {
  public var didEditText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  public var shouldPaste: ((String) -> Bool)?
  public var text: String {
    get {
      textField.text ?? ""
    }
    set {
      textField.text = newValue
    }
  }
  
  public var accessoryView: UIView? {
    get { textField.inputAccessoryView }
    set { textField.inputAccessoryView = newValue }
  }
  
  public let textField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = .clear
    textField.font = TKTextStyle.body1.font
    textField.textColor = .Text.primary
    textField.tintColor = .Text.accent
    textField.keyboardType = .alphabet
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.keyboardAppearance = .dark
    textField.returnKeyType = .next
    return textField
  }()
  
  public init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 40)
  }
  
  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    textField.becomeFirstResponder()
  }
  
  @discardableResult
  public override func resignFirstResponder() -> Bool {
    textField.resignFirstResponder()
  }
  
  public override var isFirstResponder: Bool {
    textField.isFirstResponder
  }
  
  public func setState(_ state: TKTextInputFieldState) {
    textField.tintColor = state.tintColor
  }
}

private extension TKTextInputFieldTextFieldInputControl {
  func setup() {
    textField.addTarget(self, action: #selector(didEditValue), for: .editingChanged)
    textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    textField.pasteDelegate = self
    
    addSubview(textField)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: topAnchor),
      textField.leftAnchor.constraint(equalTo: leftAnchor),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor),
      textField.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
  
  @objc
  func didEditValue() {
    didEditText?(textField.text ?? "")
  }
  
  @objc
  func textFieldDidBeginEditing() {
    didBeginEditing?()
  }
  
  @objc
  func textFieldDidEndEditing() {
    didEndEditing?()
  }
}

extension TKTextInputFieldTextFieldInputControl: UITextPasteDelegate {
  public func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting,
                                               transform item: UITextPasteItem) {
    guard let shouldPaste = shouldPaste else {
      item.setDefaultResult()
      return
    }
    guard let pasteString = UIPasteboard.general.string else {
      item.setNoResult()
      return
    }
    
    if shouldPaste(pasteString) {
      item.setDefaultResult()
    } else {
      item.setNoResult()
    }
  }
}
