import UIKit

final class TKTextFieldBackgroundView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TKTextFieldBackgroundView {
  func setup() {
    layer.borderWidth = 1.5
    layer.cornerRadius = 16
  }
}
