import UIKit

public final class TKUIListItemView: UIView, TKConfigurableView {
  
  let contentView = TKUIListItemContentView()
  let accessoryView = TKUIListItemAccessoryView()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public struct Configuration: Hashable {
    let contentConfiguration: TKUIListItemContentView.Configuration
    let accessoryConfiguration: TKUIListItemAccessoryView.Configuration
    
    public init(contentConfiguration: TKUIListItemContentView.Configuration,
                accessoryConfiguration: TKUIListItemAccessoryView.Configuration) {
      self.contentConfiguration = contentConfiguration
      self.accessoryConfiguration = accessoryConfiguration
    }
  }
  
  public func configure(configuration: Configuration) {
    contentView.configure(configuration: configuration.contentConfiguration)
    accessoryView.configure(configuration: configuration.accessoryConfiguration)
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    let accessoryViewSizeThatFits = accessoryView.sizeThatFits(
      size
    )
    let contentViewSizeThatFits = contentView.sizeThatFits(
      CGSize(
        width: size.width - accessoryViewSizeThatFits.width - 16,
        height: size.height
      )
    )
    return CGSize(width: size.width, height: contentViewSizeThatFits.height)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    accessoryView.sizeToFit()
    accessoryView.frame.origin = CGPoint(
      x: bounds.width - accessoryView.frame.width,
      y: bounds.height/2 - accessoryView.frame.height/2
    )
    contentView.frame = CGRect(x: 0, y: 0, width: bounds.width - accessoryView.frame.width - 16, height: bounds.height)
  }
}

private extension TKUIListItemView {
  func setup() {
    addSubview(contentView)
    addSubview(accessoryView)
  }
}
