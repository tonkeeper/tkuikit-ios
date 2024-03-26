import UIKit
import SnapKit

public protocol TKTextFieldInputViewControl: UIView {
  var isActive: Bool { get }
  var text: String! { get set }
  var tintColor: UIColor! { get set }
  var didUpdateText: ((String) -> Void)? { get set }
  var didBeginEditing: (() -> Void)? { get set }
  var didEndEditing: (() -> Void)? { get set }
}

public final class TKTextFieldInputView: UIControl, TKTextFieldInputViewControl {
  
  public var isActive: Bool {
    textInputControl.isActive
  }
  
  public var text: String! {
    get { textInputControl.text }
    set { textInputControl.text = newValue }
  }
  
  public override var tintColor: UIColor! {
    get { textInputControl.tintColor }
    set { textInputControl.tintColor = newValue }
  }
  
  public var didUpdateText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?

  public var padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) {
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
      self?.updateClearButtonVisibility()
    }
    button.configuration = configuration
    button.isHidden = true
    return button
  }()
  
  private var textInputControlRightEdgeConstraint: Constraint?
  private var textInputControlRightClearButtonConstraint: Constraint?

  public init(textInputControl: TKTextFieldInputViewControl) {
    self.textInputControl = textInputControl
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    textInputControl.becomeFirstResponder()
  }
  
  @discardableResult
  public override func resignFirstResponder() -> Bool {
    textInputControl.resignFirstResponder()
  }
}

private extension TKTextFieldInputView {
  func setup() {
    textInputControl.didUpdateText = { [weak self] text in
      self?.updateClearButtonVisibility()
      self?.didUpdateText?(text)
    }
    
    textInputControl.didBeginEditing = { [weak self] in
      self?.updateClearButtonVisibility()
      self?.didBeginEditing?()
    }
    
    textInputControl.didEndEditing = { [weak self] in
      self?.updateClearButtonVisibility()
      self?.didEndEditing?()
    }
    
    addSubview(textInputControl)
    addSubview(clearButton)
    
    setupConstraints()
    
    addAction(UIAction(handler: { [weak self] _ in
      self?.textInputControl.becomeFirstResponder()
    }), for: .touchUpInside)
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

  func updateClearButtonVisibility() {
    let isClearButtonVisible = !text.isEmpty && isActive
    if isClearButtonVisible {
      clearButton.isHidden = false
      textInputControlRightEdgeConstraint?.deactivate()
      textInputControlRightClearButtonConstraint?.activate()
    } else {
      clearButton.isHidden = true
      textInputControlRightClearButtonConstraint?.deactivate()
      textInputControlRightEdgeConstraint?.activate()
    }
  }
}
