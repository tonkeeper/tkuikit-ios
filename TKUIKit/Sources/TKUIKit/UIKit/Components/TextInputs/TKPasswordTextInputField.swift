import UIKit

public final class TKPasswordTextInputField: TKTextInputField<TKTextInputFieldPasswordInputControl> {
  public init() {
    super.init(inputControl: TKTextInputFieldPasswordInputControl(inputControl: TKTextInputFieldTextFieldInputControl()))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
