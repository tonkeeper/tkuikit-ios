import UIKit

public final class TKListItemTextContentView: UIView, ConfigurableView {
  let textWithTagView = TKTextWithTagView()
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
    
    let textWithTagFittingSize = textWithTagView.systemLayoutSizeFitting(bounds.size)
    let textWithTagSize = CGSize(width: min(bounds.width, textWithTagFittingSize.width),
                                 height: textWithTagFittingSize.height)
    if subtitleLabel.isHidden {
      textWithTagView.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height/2 - textWithTagSize.height/2),
                                     size: textWithTagSize)
    } else {
      let subtitleFittingSize = subtitleLabel.systemLayoutSizeFitting(bounds.size)
      let subtitleSize = CGSize(width: min(bounds.width, subtitleFittingSize.width),
                                height: subtitleFittingSize.height)
      
      textWithTagView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                     size: textWithTagSize)
      subtitleLabel.frame = CGRect(origin: CGPoint(x: 0, y: textWithTagView.frame.maxY),
                                   size: subtitleSize)
    }
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    if subtitleLabel.isHidden {
      let textWithTagSize = textWithTagView.systemLayoutSizeFitting(targetSize)
      return textWithTagSize
    } else {
      let textWithTagSize = textWithTagView.systemLayoutSizeFitting(targetSize)
      let subtitleSize = subtitleLabel.systemLayoutSizeFitting(targetSize)
      let resultSize = CGSize(
        width: max(textWithTagSize.width, subtitleSize.width),
        height: textWithTagSize.height + subtitleSize.height
      )
      return resultSize
    }
  }
  
  public struct Model {
    public let textWithTagModel: TKTextWithTagView.Model
    public let subtitle: NSAttributedString?
    
    public init(textWithTagModel: TKTextWithTagView.Model,
                attributedSubtitle: NSAttributedString?) {
      self.textWithTagModel = textWithTagModel
      self.subtitle = attributedSubtitle
    }
    
    public init(textWithTagModel: TKTextWithTagView.Model,
                subtitle: String?) {
      self.textWithTagModel = textWithTagModel
      self.subtitle = subtitle?.withTextStyle(.body2, color: .Text.secondary, alignment: .left, lineBreakMode: .byTruncatingTail)
    }
  }
  
  public func configure(model: Model) {
    textWithTagView.configure(model: model.textWithTagModel)
    
    subtitleLabel.attributedText = model.subtitle
    subtitleLabel.isHidden = model.subtitle == nil
    setNeedsLayout()
  }
}

private extension TKListItemTextContentView {
  func setup() {
    addSubview(textWithTagView)
    addSubview(subtitleLabel)
  }
}

