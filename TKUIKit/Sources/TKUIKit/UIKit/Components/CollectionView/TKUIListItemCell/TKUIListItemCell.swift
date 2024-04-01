import UIKit

public class TKUIListItemCell: TKCollectionViewNewCell, TKConfigurableView {
  let listItemView = TKUIListItemView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public struct Configuration: Hashable {
    public let id: String
    public let listItemConfiguration: TKUIListItemView.Configuration
    
    public init(id: String, listItemConfiguration: TKUIListItemView.Configuration) {
      self.id = id
      self.listItemConfiguration = listItemConfiguration
    }
  }
  
  public func configure(configuration: Configuration) {
    listItemView.configure(configuration: configuration.listItemConfiguration)
  }
  
  public override func contentSize(targetWidth: CGFloat) -> CGSize {
    listItemView.sizeThatFits(CGSize(width: targetWidth, height: 0))
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    listItemView.frame = contentContainerView.bounds
  }
}

private extension TKUIListItemCell {
  func setup() {
    backgroundColor = .Background.content
    hightlightColor = .Background.highlighted
    contentViewPadding = .init(top: 16, left: 16, bottom: 16, right: 16)
    contentContainerView.addSubview(listItemView)
  }
}
