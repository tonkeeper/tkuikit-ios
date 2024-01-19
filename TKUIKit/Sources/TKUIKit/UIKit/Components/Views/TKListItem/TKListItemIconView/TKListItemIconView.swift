import UIKit

public final class TKListItemIconView: UIView, ConfigurableView {
  
  var contentView: UIView?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView?.frame = bounds
    
    layer.cornerRadius = .imageViewSide/2
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    CGSize(width: .imageViewSide, height: .imageViewSide)
  }

  public enum Model {
    case emoji(emoji: String, backgroundColor: UIColor)
  }
  
  public func configure(model: Model) {
    self.contentView?.removeFromSuperview()
    switch model {
    case let .emoji(emoji, backgroundColor):
      let contentView = TKListItemIconEmojiContentView()
      contentView.configure(model: TKListItemIconEmojiContentView.Model(
        emoji: emoji,
        backgroundColor: backgroundColor)
      )
      addSubview(contentView)
      self.contentView = contentView
    }
  }
}

private extension TKListItemIconView {
  func setup() {
    layer.masksToBounds = true
  }
}

private extension CGFloat {
  static let imageViewSide: CGFloat = 44
}

