import UIKit
import SnapKit

protocol TKTextFieldInputViewControl: UIView {
  var isActive: Bool { get }
  var text: String! { get set }
  var tintColor: UIColor! { get set }
  var didUpdateText: ((String) -> Void)? { get set }
  var didBeginEditing: (() -> Void)? { get set }
  var didEndEditing: (() -> Void)? { get set }
}

final class TKTextFieldInputView: UIView, TKTextFieldInputViewControl {
  
  var isActive: Bool {
    textInputControl.isActive
  }
  
  var text: String! {
    get { textInputControl.text }
    set { textInputControl.text = newValue }
  }
  
  override var tintColor: UIColor! {
    get { textInputControl.tintColor }
    set { textInputControl.tintColor = newValue }
  }
  
  var didUpdateText: ((String) -> Void)?
  var didBeginEditing: (() -> Void)?
  var didEndEditing: (() -> Void)?

  var padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) {
    didSet {
      textInputControl.snp.remakeConstraints { make in
        make.top.left.bottom.equalTo(self).inset(padding)
        textInputControlRightEdgeConstraint = make.right.equalTo(self).inset(padding).constraint
      }
    }
  }
  
  private let textInputControl: TKTextFieldInputViewControl
  private lazy var clearButton: TKButton = {
    let button = TKButton()
    button.setContentHuggingPriority(.required, for: .horizontal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    var configuration = TKButton.Configuration.fiedClearButtonConfiguration()
    configuration.action = { [weak self] in
      self?.textInputControl.text = ""
      self?.didUpdateText?("")
      self?.textInputControlDidUpdateText("")
    }
    button.configuration = configuration
    button.isHidden = true
    return button
  }()
  
  private var textInputControlRightEdgeConstraint: Constraint?
  private var textInputControlRightClearButtonConstraint: Constraint?

  init(textInputControl: TKTextFieldInputViewControl) {
    self.textInputControl = textInputControl
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TKTextFieldInputView {
  func setup() {
    textInputControl.didUpdateText = { [weak self] text in
      self?.textInputControlDidUpdateText(text)
      self?.didUpdateText?(text)
    }
    
    textInputControl.didBeginEditing = { [weak self] in
      self?.didBeginEditing?()
    }
    
    textInputControl.didEndEditing = { [weak self] in
      self?.didEndEditing?()
    }
    
    addSubview(textInputControl)
    addSubview(clearButton)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    textInputControl.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    textInputControl.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    textInputControl.snp.makeConstraints { make in
      make.top.left.bottom.equalTo(self).inset(padding)
      textInputControlRightEdgeConstraint = make.right.equalTo(self).inset(padding).constraint
      textInputControlRightClearButtonConstraint = make.right.equalTo(clearButton.snp.left).constraint
    }
    textInputControlRightClearButtonConstraint?.deactivate()
    
    clearButton.snp.makeConstraints { make in
      make.top.right.bottom.equalTo(self)
    }
  }
  
  func textInputControlDidUpdateText(_ text: String) {
    if text.isEmpty {
      clearButton.isHidden = true
      textInputControlRightClearButtonConstraint?.deactivate()
      textInputControlRightEdgeConstraint?.activate()
    } else {
      clearButton.isHidden = false
      textInputControlRightEdgeConstraint?.deactivate()
      textInputControlRightClearButtonConstraint?.activate()
    }
  }
}

final class TKTextInputTextViewControl: UITextView, TKTextFieldInputViewControl {
  var didUpdateText: ((String) -> Void)?
  var didBeginEditing: (() -> Void)?
  var didEndEditing: (() -> Void)?
  
  var isActive: Bool {
    isFirstResponder
  }
  
  init() {
    let storage = NSTextStorage()
    let manager = NSLayoutManager()
    let container = NSTextContainer()
    storage.addLayoutManager(manager)
    manager.addTextContainer(container)
    super.init(frame: .zero, textContainer: container)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TKTextInputTextViewControl {
  func setup() {
    isScrollEnabled = false
    backgroundColor = .clear
    delegate = self
    textContainer.lineFragmentPadding = TKTextStyle.body1.lineSpacing
    textContainerInset = .zero
    typingAttributes = TKTextStyle.body1.getAttributes(color: .Text.primary, alignment: .left, lineBreakMode: .byWordWrapping)
  }
}

extension TKTextInputTextViewControl: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    didUpdateText?(textView.text)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing?()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing?()
  }
}
