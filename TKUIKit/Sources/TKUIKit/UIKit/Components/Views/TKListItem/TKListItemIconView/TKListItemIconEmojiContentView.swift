import UIKit

public final class TKListItemIconEmojiContentView: UIView, ConfigurableView, ReusableView {
  
  let emojiLabel = UILabel()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    emojiLabel.sizeToFit()
    emojiLabel.center = CGPoint(x: bounds.width/2,
                                y: bounds.height/2)
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    CGSize(width: .imageViewSide, height: .imageViewSide)
  }

  public struct Model {
    public let emoji: String
    public let backgroundColor: UIColor
    
    public init(emoji: String,
                backgroundColor: UIColor) {
      self.emoji = emoji
      self.backgroundColor = backgroundColor
    }
  }
  
  public func configure(model: Model) {
    emojiLabel.text = model.emoji
    backgroundColor = model.backgroundColor
  }
}

private extension TKListItemIconEmojiContentView {
  func setup() {
    emojiLabel.font = .systemFont(ofSize: 24)
    emojiLabel.textAlignment = .center
    
    addSubview(emojiLabel)
  }
}

private extension CGFloat {
  static let imageViewSide: CGFloat = 44
}
