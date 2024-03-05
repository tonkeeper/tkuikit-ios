import UIKit

extension UITextView: TKTextInputInputView {}

public final class TKTextView: TKTextInput<UITextView> {
  
  public override var text: String {
    didSet {
      textInputView.text = text
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    textInputView.backgroundColor = .clear
    textInputView.font = TKTextStyle.body1.font
    textInputView.textColor = .Text.primary
    textInputView.textContainer.lineFragmentPadding = 0
    textInputView.textContainerInset = .init(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0)
    textInputView.isScrollEnabled = false
    textInputView.keyboardType = .alphabet
    textInputView.autocapitalizationType = .none
    textInputView.autocorrectionType = .no
    textInputView.keyboardAppearance = .dark
    textInputView.returnKeyType = .next
    
    let textStyle = TKTextStyle.body1
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = textStyle.lineHeight
    paragraphStyle.maximumLineHeight = textStyle.lineHeight
    paragraphStyle.alignment = .left
    paragraphStyle.lineBreakMode = .byCharWrapping
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: textStyle.font,
      .foregroundColor: UIColor.Text.primary,
      .paragraphStyle: paragraphStyle,
      .baselineOffset: (textStyle.lineHeight - textStyle.font.lineHeight)/2
    ]
    
    textInputView.typingAttributes = attributes
    textInputView.delegate = self
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didUpdateState() {
    super.didUpdateState()
    textInputView.tintColor = textInputState.tintColor
  }
}

extension TKTextView: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    didEditText?(textView.text ?? "")
    super.text = textView.text ?? ""
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    self.updateState()
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    self.updateState()
  }
}
