import UIKit

public protocol TKTextInputFieldInputControl: UIView {
  var didEditText: ((String) -> Void)? { get set }
  var didBeginEditing: (() -> Void)? { get set }
  var didEndEditing: (() -> Void)? { get set }
  var shouldPaste: ((String) -> Bool)? { get set }
  var shouldReturn: (() -> Bool)? { get set }
  
  var text: String { get set }
  
  var accessoryView: UIView? { get set }
  
  func setState(_ state: TKTextInputFieldState)
}

public extension TKTextInputFieldInputControl {
  func setState(_ state: TKTextInputFieldState) {}
}

open class TKTextInputField<InputControl: TKTextInputFieldInputControl>: UIView, TKTextInputFieldInputControl {
  
  public var isValid: Bool = true {
    didSet {
      updateState()
    }
  }
  
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
  
  var state: TKTextInputFieldState = .inactive {
    didSet {
      setupState()
    }
  }
  
  public var accessoryView: UIView? {
    get { inputControl.accessoryView }
    set { inputControl.accessoryView = newValue }
  }
  
  public let inputControl: InputControl
  private let backgroundView = TKTextInputFieldBackgroundView()
  
  public init(inputControl: InputControl) {
    self.inputControl = inputControl
    super.init(frame: .zero)
    setup()
  }
  
  required public init?(coder: NSCoder) {
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
    return inputControl.isFirstResponder
  }
  
  func setupState() {
    UIView.animate(withDuration: 0.2) { [state, inputControl, backgroundView] in
      backgroundView.state = state
      inputControl.setState(state)
    }
  }
}

private extension TKTextInputField {
  func setup() {
    addSubview(backgroundView)
    addSubview(inputControl)
    
    setupConstraints()
    setupTextInputViewEvents()
    setupState()
  }
  
  func setupTextInputViewEvents() {
    inputControl.didEditText = { [weak self] text in
      self?.didEditText?(text)
    }
    inputControl.didBeginEditing = { [weak self] in
      self?.didBeginEditing?()
      self?.updateState()
    }
    inputControl.didEndEditing = { [weak self] in
      self?.didEndEditing?()
      self?.updateState()
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
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: topAnchor),
      backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
      backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
      
      inputControl.topAnchor.constraint(equalTo: topAnchor, constant: textInputViewPadding.top),
      inputControl.leftAnchor.constraint(equalTo: leftAnchor, constant: textInputViewPadding.left),
      inputControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -textInputViewPadding.bottom),
      inputControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -textInputViewPadding.right)
    ])
  }
  
  func updateState() {
    let isFirstResponder = isFirstResponder
    switch (isFirstResponder, isValid) {
    case (false, true):
      state = .inactive
    case (true, true):
      state = .active
    case (false, false):
      state = .error
    case (true, false):
      state = .error
    }
  }
}

private extension TKTextInputField {
  var textInputViewPadding: UIEdgeInsets {
    .init(top: 12, left: 16, bottom: 12, right: 16)
  }
}
