import UIKit

open class TKActionButton: TKButton {
  
  var category: TKUIActionButtonCategory {
    didSet {
      didUpdateCategory()
    }
  }
  var size: TKUIActionButtonSize {
    didSet {
      didUpdateSize()
    }
  }
  
  public init(category: TKUIActionButtonCategory, 
              size: TKUIActionButtonSize) {
    self.category = category
    self.size = size
    super.init(frame: .zero)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: size.height)
  }
}

private extension TKActionButton {
  func setup() {
    didUpdateCategory()
    didUpdateSize()
  }
  
  func didUpdateCategory() {
    backgroundColors = [.normal: category.backgroundColor,
                        .highlighted: category.highlightedBackgroundColor,
                        .disabled: category.disabledBackgroundColor]
    foregroundColors = [.normal: category.titleColor,
                        .highlighted: category.titleColor,
                        .disabled: category.disabledTitleColor]
  }
  
  func didUpdateSize() {
    cornerRadius = size.cornerRadius
    contentPadding = size.padding
    textStyle = size.textStyle
    invalidateIntrinsicContentSize()
  }
}
