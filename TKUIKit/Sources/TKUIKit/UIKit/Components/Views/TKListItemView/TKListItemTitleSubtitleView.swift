import UIKit

public final class TKListItemTitleSubtitleView: UIView, ReusableView {
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let titleSize = titleLabel.tkSizeThatFits(size)
    let subtitleSize = subtitleLabel.tkSizeThatFits(size)
    
    let width = [titleSize.width, subtitleSize.width].max() ?? 0
    let height = titleSize.height + subtitleSize.height
    
    return CGSize(
      width: width,
      height: height
    )
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let subtitleSizeToFit = subtitleLabel.tkSizeThatFits(CGSize(width: bounds.width, height: 0))
    let subtitleSize = CGSize(width: bounds.width, height: subtitleSizeToFit.height)
    let subtitleOrigin = CGPoint(x: 0, y: bounds.height - subtitleSize.height)
    let subtitleFrame = CGRect(origin: subtitleOrigin, size: subtitleSize)
    
    let titleSize = CGSize(width: bounds.width, height: bounds.height - subtitleSize.height)
    let titleOrigin = CGPoint.zero
    let titleFrame = CGRect(origin: titleOrigin, size: titleSize)
    
    titleLabel.frame = titleFrame
    subtitleLabel.frame = subtitleFrame
  }
  
  public struct Model {
    public let title: NSAttributedString?
    public let subtitle: NSAttributedString?
    
    public init(title: NSAttributedString?, subtitle: NSAttributedString?) {
      self.title = title
      self.subtitle = subtitle
    }
  }
  
  public func configure(model: Model) {
    titleLabel.attributedText = model.title
    subtitleLabel.attributedText = model.subtitle
  }
  
  public func prepareForReuse() {
    titleLabel.attributedText = nil
    subtitleLabel.attributedText = nil
  }
}

private extension TKListItemTitleSubtitleView {
  func setup() {
    titleLabel.numberOfLines = 1
    addSubview(titleLabel)
    addSubview(subtitleLabel)
  }
}
