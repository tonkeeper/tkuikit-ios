import UIKit

public final class TKUIListItemIconView: UIView, TKConfigurableView {
  
  private var iconView: UIView?
  private var alignment: Configuration.Alignment = .top

  public struct Configuration: Hashable {
    public enum Alignment: Hashable {
      case top
      case center
    }
    
    public enum IconConfiguration: Hashable {
      case none
      case image(TKUIListItemImageIconView.Configuration)
    }
    
    public let iconConfiguration: IconConfiguration
    public let alignment: Alignment
    
    public init(iconConfiguration: IconConfiguration, alignment: Alignment) {
      self.iconConfiguration = iconConfiguration
      self.alignment = alignment
    }
  }
  
  public func configure(configuration: Configuration) {
    switch configuration.iconConfiguration {
    case .none:
      configureNone()
    case .image(let configuration):
      configure(imageIconConfiguration: configuration)
    }
    self.alignment = configuration.alignment
    setNeedsLayout()
  }

  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    guard let iconView = iconView else { return .zero }
    return iconView.sizeThatFits(size)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if let iconView = iconView {
      iconView.sizeToFit()
      switch alignment {
      case .top:
        iconView.center = CGPoint(
          x: bounds.width/2,
          y: 0
        )
      case .center:
        iconView.center = CGPoint(
          x: bounds.width/2,
          y: bounds.height/2
        )
      }
    }
  }
}

private extension TKUIListItemIconView {
  func configureNone() {
    iconView?.removeFromSuperview()
    iconView = nil
  }
  
  func configure(imageIconConfiguration: TKUIListItemImageIconView.Configuration) {
    if let imageIconView = iconView as? TKUIListItemImageIconView {
      imageIconView.configure(configuration: imageIconConfiguration)
    } else {
      iconView?.removeFromSuperview()
      let imageIconView = TKUIListItemImageIconView()
      imageIconView.configure(configuration: imageIconConfiguration)
      addSubview(imageIconView)
      iconView = imageIconView
    }
  }
}
