import UIKit

public final class TKTextInputFieldTextViewInputControl: UIView, TKTextInputFieldInputControl {
  private let textView: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = .clear
    textView.font = TKTextStyle.body1.font
    textView.textColor = .Text.primary
    textView.textContainer.lineFragmentPadding = 0
    textView.textContainerInset = .init(
      top: 10,
      left: 0,
      bottom: 10,
      right: 0)
    textView.isScrollEnabled = false
    textView.keyboardType = .alphabet
    textView.autocapitalizationType = .none
    textView.autocorrectionType = .no
    textView.keyboardAppearance = .dark
    textView.returnKeyType = .next
    return textView
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
  
  // MARK: - TKTextInputFieldInputControl
  
  public var didEditText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  public var shouldPaste: ((String) -> Bool)?
  public var shouldReturn: (() -> Bool)?
  
  public var text: String {
    get {
      textView.text ?? ""
    }
    set {
      textView.text = newValue
    }
  }
  
  public var accessoryView: UIView? {
    get { textView.inputAccessoryView }
    set { textView.inputAccessoryView = newValue }
  }
  
  public func setState(_ state: TKTextInputFieldState) {
    textView.tintColor = state.tintColor
  }
  
  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    return textView.becomeFirstResponder()
  }
  
  @discardableResult
  public override func resignFirstResponder() -> Bool {
    return textView.resignFirstResponder()
  }
  
  public override var isFirstResponder: Bool {
    textView.isFirstResponder
  }
}

private extension TKTextInputFieldTextViewInputControl {
  func setup() {
    textView.delegate = self
    textView.pasteDelegate = self
    
    addSubview(textView)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: topAnchor),
      textView.leftAnchor.constraint(equalTo: leftAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}

extension TKTextInputFieldTextViewInputControl: UITextViewDelegate {
  public func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing?()
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing?()
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    didEditText?(textView.text)
  }
}

extension TKTextInputFieldTextViewInputControl: UITextPasteDelegate {
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
