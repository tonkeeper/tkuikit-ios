import UIKit

public final class TKUIListItemContentView: UIView, TKConfigurableView {
  
  let leftItem = TKUIListItemContentLeftItem()
  let rightItem = TKUIListItemContentRightItem()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let rightItemSize = rightItem.sizeThatFits(
      CGSize(width: size.width,
             height: size.height)
    )
    let leftItemSize = leftItem.sizeThatFits(
      CGSize(
        width: size.width - rightItemSize.width,
        height: size.height
      )
    )
    
    let height = [rightItemSize.height, leftItemSize.height].max() ?? 0
    return CGSize(width: size.width,
                  height: height)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let rightItemSizeToFit = rightItem.sizeThatFits(CGSize(width: bounds.width, height: bounds.height))
    let rightItemSize = CGSize(width: rightItemSizeToFit.width, height: bounds.height)
    let rightItemFrame = CGRect(origin: CGPoint(x: bounds.width - rightItemSize.width, y: 0),
                                size: rightItemSize)
    
    let leftItemSizeToFit = leftItem.sizeThatFits(
      CGSize(
        width: bounds.width - rightItemSize.width,
        height: bounds.height
      )
    )
    let leftItemSize = CGSize(width: leftItemSizeToFit.width, height: bounds.height)
    let leftItemFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: leftItemSize)
    rightItem.frame = rightItemFrame
    leftItem.frame = leftItemFrame
  }
  
  public struct Configuration: Hashable {
    public let leftItemConfiguration: TKUIListItemContentLeftItem.Configuration?
    public let rightItemConfiguration: TKUIListItemContentRightItem.Configuration?
    
    public init(leftItemConfiguration: TKUIListItemContentLeftItem.Configuration?,
                rightItemConfiguration: TKUIListItemContentRightItem.Configuration?) {
      self.leftItemConfiguration = leftItemConfiguration
      self.rightItemConfiguration = rightItemConfiguration
    }
  }
  
  public func configure(configuration: Configuration) {
    if let leftItemConfiguration = configuration.leftItemConfiguration {
      leftItem.configure(configuration: leftItemConfiguration)
      leftItem.isHidden = false
    } else {
      leftItem.isHidden = true
    }
    if let rightItemConfiguration = configuration.rightItemConfiguration {
      rightItem.configure(configuration: rightItemConfiguration)
      rightItem.isHidden = false
    } else {
      rightItem.isHidden = true
    }
    setNeedsLayout()
  }
}

private extension TKUIListItemContentView {
  func setup() {
    addSubview(leftItem)
    addSubview(rightItem)
  }
}
