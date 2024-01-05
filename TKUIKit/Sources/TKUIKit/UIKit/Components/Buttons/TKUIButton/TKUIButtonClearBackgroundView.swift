import UIKit

public final class TKUIButtonClearBackgroundView: UIView, TKUIButtonBackgroundView {
  public func setBackgroundColor(_ color: UIColor) {}
  
  init() {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
