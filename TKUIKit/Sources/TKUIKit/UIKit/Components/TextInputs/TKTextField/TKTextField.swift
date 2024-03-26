import UIKit

public final class TKTextField: UIControl {
  
  public var isActive: Bool {
    textFieldInputView.isActive
  }
  
  public var text: String! {
    get { textFieldInputView.text }
    set { textFieldInputView.text = newValue }
  }
  
  public var didUpdateText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  
  var textFieldState: TKTextFieldState = .inactive {
    didSet {
      didUpdateState()
    }
  }
  
  private let backgroundView = TKTextFieldBackgroundView()
  private let textFieldInputView: TKTextFieldInputView
  
  public init(textFieldInputView: TKTextFieldInputView) {
    self.textFieldInputView = textFieldInputView
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    textFieldInputView.becomeFirstResponder()
  }
  
  @discardableResult
  public override func resignFirstResponder() -> Bool {
    textFieldInputView.resignFirstResponder()
  }
}

private extension TKTextField {
  func setup() {
    textFieldInputView.didUpdateText = { [weak self] text in
      self?.didUpdateText?(text)
    }
    
    textFieldInputView.didBeginEditing = { [weak self] in
      self?.didUpdateActiveState()
    }
    
    textFieldInputView.didEndEditing = { [weak self] in
      self?.didUpdateActiveState()
    }
    
    didUpdateState()
    
    backgroundView.isUserInteractionEnabled = false
    
    addSubview(backgroundView)
    addSubview(textFieldInputView)
    
    setupConstraints()
    
    addAction(UIAction(handler: { [weak self] _ in
      self?.textFieldInputView.becomeFirstResponder()
    }), for: .touchUpInside)
  }
  
  func setupConstraints() {
    backgroundView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
    
    textFieldInputView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
  }
  
  func didUpdateState() {
    UIView.animate(withDuration: 0.2) { [backgroundView, textFieldInputView, textFieldState] in
      backgroundView.backgroundColor = textFieldState.backgroundColor
      backgroundView.layer.borderColor = textFieldState.borderColor.cgColor
      textFieldInputView.tintColor = textFieldState.tintColor
    }
  }
  
  func didUpdateActiveState() {
    let isValid = true
    switch (isActive, isValid) {
    case (false, true):
      textFieldState = .inactive
    case (true, true):
      textFieldState = .active
    case (false, false):
      textFieldState = .error
    case (true, false):
      textFieldState = .error
    }
  }
}
