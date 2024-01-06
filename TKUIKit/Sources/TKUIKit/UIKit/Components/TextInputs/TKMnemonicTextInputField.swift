import UIKit

public extension TKTextInputField where InputControl == TKTextInputFieldMnemonicInputControl {
  var indexNumber: Int {
    get {
      inputControl.indexNumber
    }
    set {
      inputControl.indexNumber = newValue
    }
  }
}

public final class TKMnemonicTextInputField: TKTextInputField<TKTextInputFieldMnemonicInputControl> {
  public init() {
    super.init(inputControl: TKTextInputFieldMnemonicInputControl(inputControl: TKTextInputFieldTextFieldInputControl()))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
