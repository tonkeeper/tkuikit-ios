import UIKit

public final class TKListItemView: UIView, ConfigurableView, ReusableView {
  let iconView = TKListItemIconView()
  let textContentView = TKListItemTextContentView()
  let valueView = TKListItemValueView()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    var originX: CGFloat = 0
    var estimatedWidth = bounds.width
    
    let iconFittingSize = iconView.isHidden ? .zero : iconView.systemLayoutSizeFitting(bounds.size)
    let iconRightInset: CGFloat = iconView.isHidden ? 0 : .textContentLeftPadding
    iconView.frame = CGRect(origin: CGPoint(x: originX, y: 0),
                            size: CGSize(width: iconFittingSize.width, height: bounds.height))
    estimatedWidth -= iconFittingSize.width + iconRightInset
    originX = iconView.frame.maxX + iconRightInset
    
    let valueViewFittingSize = valueView.systemLayoutSizeFitting(
      CGSize(width: estimatedWidth,
             height: 0)
    )
    let valueViewSize = CGSize(
      width: min(estimatedWidth, valueViewFittingSize.width),
      height: valueViewFittingSize.height
    )
    let valueViewLeftInset: CGFloat = valueView.isHidden ? 0 : .textContentLeftPadding
    valueView.frame = CGRect(
      origin: CGPoint(x: bounds.width - valueViewSize.width, y: 0),
      size: valueViewSize
    )
    estimatedWidth -= valueViewSize.width + valueViewLeftInset
    
    let textContenViewFittingSize = textContentView.systemLayoutSizeFitting(CGSize(width: estimatedWidth, height: 0))
    let textContentViewSize = CGSize(
      width: min(estimatedWidth, textContenViewFittingSize.width),
      height: textContenViewFittingSize.height
    )
    textContentView.frame = CGRect(origin: CGPoint(x: originX, y: 0),
                                  size: textContentViewSize)
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    var estimatedWidth = targetSize.width
    
    let iconFittingSize: CGSize = iconView.isHidden ? .zero : iconView.systemLayoutSizeFitting(targetSize)
    let iconRightInset: CGFloat = iconView.isHidden ? 0 : .textContentLeftPadding
    estimatedWidth -= iconFittingSize.width + iconRightInset
    
    let valueFittingSize = valueView.systemLayoutSizeFitting(CGSize(width: estimatedWidth, height: targetSize.height))
    let valueLeftInset: CGFloat = valueView.isHidden ? 0 : .textContentLeftPadding
    estimatedWidth -= valueFittingSize.width + valueLeftInset
    
    let textContentFittingSize = textContentView.systemLayoutSizeFitting(
      CGSize(width: estimatedWidth,
             height: targetSize.height)
    )
    
    let resultWidth = targetSize.width
    let resultHeight = max(max(iconFittingSize.height, valueFittingSize.height), textContentFittingSize.height)
    return CGSize(width: resultWidth, height: resultHeight)
  }
  
  public func prepareForReuse() {
    iconView.prepareForReuse()
  }
  
  public struct Model {
    public let iconModel: TKListItemIconView.Model?
    public let textContentModel: TKListItemTextContentView.Model
    public let valueModel: TKListItemValueView.Model?
    
    public init(iconModel: TKListItemIconView.Model?,
                textContentModel: TKListItemTextContentView.Model,
                valueModel: TKListItemValueView.Model? = nil) {
      self.iconModel = iconModel
      self.textContentModel = textContentModel
      self.valueModel = valueModel
    }
  }
  
  public func configure(model: Model) {
    if let iconModel = model.iconModel {
      iconView.configure(model: iconModel)
      iconView.isHidden = false
    } else {
      iconView.isHidden = true
    }
    textContentView.configure(model: model.textContentModel)
    if let valueModel = model.valueModel {
      valueView.configure(model: valueModel)
      valueView.isHidden = false
    } else {
      valueView.isHidden = true
    }
    
    setNeedsLayout()
  }
}

private extension TKListItemView {
  func setup() {
    addSubview(iconView)
    addSubview(textContentView)
    addSubview(valueView)
  }
}

private extension CGFloat {
  static let textContentLeftPadding: CGFloat = 16
}

