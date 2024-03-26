import UIKit

public final class TKTextInputTextViewControl: UITextView, TKTextFieldInputViewControl {
  public var didUpdateText: ((String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  public var didEndEditing: (() -> Void)?
  
  public var isActive: Bool {
    isFirstResponder
  }
  
  public init() {
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
  public func textViewDidChange(_ textView: UITextView) {
    didUpdateText?(textView.text)
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing?()
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing?()
  }
}
