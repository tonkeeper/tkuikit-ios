import UIKit

public final class TKHeaderButton: TKButton {
  
  public var category: TKUIActionButtonCategory {
    didSet {
      didUpdateCategory()
    }
  }
  init(category: TKUIActionButtonCategory = .secondary) {
    self.category = category
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: .height)
  }
}

private extension TKHeaderButton {
  func setup() {
    textStyle = .label2
    cornerRadius = .cornerRadius
    contentPadding = .padding
    didUpdateCategory()
  }
  
  func didUpdateCategory() {
    backgroundColors = [.normal: category.backgroundColor,
                        .highlighted: category.highlightedBackgroundColor,
                        .disabled: category.disabledBackgroundColor]
    foregroundColors = [.normal: category.titleColor,
                        .highlighted: category.titleColor,
                        .disabled: category.disabledTitleColor]
  }
}

private extension CGFloat {
  static let height: CGFloat = 32
  static let cornerRadius: CGFloat = 16
}

private extension UIEdgeInsets {
  static let padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
}
