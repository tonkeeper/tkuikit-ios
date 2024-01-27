import UIKit

public final class TKListItemValueTextContentView: UIView, ConfigurableView {
  let topValueLabel = UILabel()
  let bottomValueLabel = UILabel()
  let subtitleLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let topValueFittingSize = topValueLabel.systemLayoutSizeFitting(bounds.size)
    let topValueSize = CGSize(width: min(bounds.width, topValueFittingSize.width),
                              height: topValueFittingSize.height)
    
    let bottomValueFittingSize = bottomValueLabel.systemLayoutSizeFitting(bounds.size)
    let bottomValueSize = CGSize(width: min(bounds.width, bottomValueFittingSize.width),
                              height: bottomValueFittingSize.height)
    
    let subtitleFittingSize = subtitleLabel.systemLayoutSizeFitting(bounds.size)
    let subtitleSize = CGSize(width: min(bounds.width, subtitleFittingSize.width),
                              height: subtitleFittingSize.height)
    
    topValueLabel.frame = CGRect(origin: CGPoint(x: bounds.width - topValueSize.width, y: 0),
                                 size: topValueSize)
    bottomValueLabel.frame = CGRect(origin: CGPoint(x: bounds.width - bottomValueSize.width, y: topValueLabel.frame.maxY),
                                 size: bottomValueSize)
    subtitleLabel.frame = CGRect(origin: CGPoint(x: bounds.width - subtitleSize.width, y: bottomValueLabel.frame.maxY),
                                 size: subtitleSize)
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    let topValueSize = topValueLabel.systemLayoutSizeFitting(targetSize)
    let bottomValueSize = bottomValueLabel.systemLayoutSizeFitting(targetSize)
    let subtitleValueSize = subtitleLabel.systemLayoutSizeFitting(targetSize)
    let resultSize = CGSize(
      width: [topValueSize.width, bottomValueSize.width, subtitleValueSize.width].max() ?? 0,
      height: topValueSize.height + bottomValueSize.height + subtitleValueSize.height
    )
    return resultSize
  }
  
  public struct Model {
    public let topValue: NSAttributedString?
    public let bottomValue: NSAttributedString?
    public let subtitle: NSAttributedString?
    
    public init(topValue: NSAttributedString?,
                bottomValue: NSAttributedString? = nil,
                subtitle: NSAttributedString? = nil) {
      self.topValue = topValue
      self.bottomValue = bottomValue
      self.subtitle = subtitle
    }
  }
  
  public func configure(model: Model) {
    topValueLabel.attributedText = model.topValue
    bottomValueLabel.attributedText = model.bottomValue
    subtitleLabel.attributedText = model.subtitle
    setNeedsLayout()
  }
}

private extension TKListItemValueTextContentView {
  func setup() {
    addSubview(topValueLabel)
    addSubview(bottomValueLabel)
    addSubview(subtitleLabel)
  }
}

