import UIKit

public final class TKUIButtonDefaultBackgroundView: UIView {
  
  let cornerRadius: CGFloat
  
  init(cornerRadius: CGFloat) {
    self.cornerRadius = cornerRadius
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
  }
  
  public func setBackgroundColor(_ color: UIColor) {
    backgroundColor = color
  }
}
