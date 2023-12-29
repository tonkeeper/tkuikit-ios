import UIKit

public final class TKUIScrollView: UIScrollView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    delaysContentTouches = false
    canCancelContentTouches = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func touchesShouldCancel(in view: UIView) -> Bool {
    guard !(view is UIControl) else { return true }
    return super.touchesShouldCancel(in: view)
  }
}
