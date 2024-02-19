import UIKit

public final class TKHeaderIconButton: TKButton {
  
  var category: TKUIActionButtonCategory {
    didSet {
      didUpdateCategory()
    }
  }
  init(category: TKUIActionButtonCategory) {
    self.category = category
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: .side, height: .side)
  }
}

private extension TKHeaderIconButton {
  func setup() {
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
  static let side: CGFloat = 32
  static let cornerRadius: CGFloat = 16
}

private extension UIEdgeInsets {
  static let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}
