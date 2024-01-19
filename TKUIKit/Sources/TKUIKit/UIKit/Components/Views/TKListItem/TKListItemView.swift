import UIKit

public final class TKListItemView: UIView, ConfigurableView {
  let iconView = TKListItemIconView()
  let textContenView = TKListItemTextContentView()

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
    
    if !iconView.isHidden {
      let iconFittingSize = iconView.systemLayoutSizeFitting(bounds.size)
      iconView.frame = CGRect(origin: CGPoint(x: originX, y: 0),
                              size: iconFittingSize)
      estimatedWidth -= iconFittingSize.width + .textContentLeftPadding
      originX = iconView.frame.maxX + .textContentLeftPadding
    }
    
    let textContenViewFittingSize = textContenView.systemLayoutSizeFitting(CGSize(width: estimatedWidth, height: 0))
    let textContentViewSize = CGSize(
      width: min(estimatedWidth, textContenViewFittingSize.width),
      height: textContenViewFittingSize.height
    )
    
    textContenView.frame = CGRect(origin: CGPoint(x: originX, y: bounds.height/2 - textContentViewSize.height/2),
                                  size: textContentViewSize)
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    if iconView.isHidden {
      let textContentFittingSize = textContenView.systemLayoutSizeFitting(
        CGSize(width: bounds.width,
               height: targetSize.height)
      )
      let resultWidth = textContentFittingSize.width
      let resultHeight = textContentFittingSize.height
      return CGSize(width: resultWidth, height: resultHeight)
    } else {
      let iconFittingSize = iconView.systemLayoutSizeFitting(targetSize)
      
      var estimatedWidth = targetSize.width - iconFittingSize.width
      estimatedWidth -= .textContentLeftPadding
      
      let textContentFittingSize = textContenView.systemLayoutSizeFitting(
        CGSize(width: estimatedWidth,
               height: targetSize.height)
      )
      
      let resultWidth = iconFittingSize.width + .textContentLeftPadding + textContentFittingSize.width
      let resultHeight = max(iconFittingSize.height, textContentFittingSize.height)
      return CGSize(width: resultWidth, height: resultHeight)
    }
  }
  
  public struct Model {
    public let iconModel: TKListItemIconView.Model?
    public let textContentModel: TKListItemTextContentView.Model
    
    public init(iconModel: TKListItemIconView.Model?,
                textContentModel: TKListItemTextContentView.Model) {
      self.iconModel = iconModel
      self.textContentModel = textContentModel
    }
  }
  
  public func configure(model: Model) {
    if let iconModel = model.iconModel {
      iconView.configure(model: iconModel)
      iconView.isHidden = false
    } else {
      iconView.isHidden = true
    }
    textContenView.configure(model: model.textContentModel)
    setNeedsLayout()
  }
}

private extension TKListItemView {
  func setup() {
    addSubview(iconView)
    addSubview(textContenView)
  }
}

private extension CGFloat {
  static let textContentLeftPadding: CGFloat = 16
}

