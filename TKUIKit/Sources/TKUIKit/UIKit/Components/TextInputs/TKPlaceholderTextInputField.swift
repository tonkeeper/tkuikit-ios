import UIKit

public extension TKTextInputField where InputControl == TKTextInputFieldPlaceholderInputControl {
  var placeholder: String {
    get {
      inputControl.placeholder
    }
    set {
      inputControl.placeholder = newValue
    }
  }
}

public final class TKPlaceholderTextInputField: TKTextInputField<TKTextInputFieldPlaceholderInputControl> {
  public enum Mode {
    case singleline
    case multiline
    
    var inputControl: TKTextInputFieldInputControl {
      switch self {
      case .singleline:
        TKTextInputFieldTextFieldInputControl()
      case .multiline:
        TKTextInputFieldTextViewInputControl()
      }
    }
  }
  
  public init(mode: Mode) {
    super.init(inputControl: TKTextInputFieldPlaceholderInputControl(inputControl: mode.inputControl))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
