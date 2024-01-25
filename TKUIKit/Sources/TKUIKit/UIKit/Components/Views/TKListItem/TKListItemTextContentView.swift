import UIKit

public final class TKListItemTextContentView: UIView, ConfigurableView {
  let textWithTagView = TKTextWithTagView()
  let subtitleLabel = UILabel()
  let descriptionLabel = UILabel()
  
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
//    if subtitleLabel.isHidden {
//      textWithTagView.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height/2 - textWithTagSize.height/2),
//                                     size: textWithTagSize)
//    } else {
      let subtitleFittingSize = subtitleLabel.systemLayoutSizeFitting(bounds.size)
      let subtitleSize = CGSize(width: min(bounds.width, subtitleFittingSize.width),
                                height: subtitleFittingSize.height)
    let descriptionSize = descriptionLabel.systemLayoutSizeFitting(bounds.size)
      
      textWithTagView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                     size: textWithTagSize)
      subtitleLabel.frame = CGRect(origin: CGPoint(x: 0, y: textWithTagView.frame.maxY),
                                   size: subtitleSize)
    descriptionLabel.frame = CGRect(origin: CGPoint(x: 0, y: subtitleLabel.frame.maxY),
                                    size: descriptionSize)
//    }
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    let textWithTagSize = textWithTagView.systemLayoutSizeFitting(targetSize)
    let subtitleSize = subtitleLabel.systemLayoutSizeFitting(targetSize)
    let descriptionSize = descriptionLabel.systemLayoutSizeFitting(targetSize)
    let resultSize = CGSize(
      width: targetSize.width,
      height: textWithTagSize.height + subtitleSize.height + descriptionSize.height
    )
    return resultSize
  }
  
  public struct Model {
    public let textWithTagModel: TKTextWithTagView.Model
    public let subtitle: NSAttributedString?
    public let description: NSAttributedString?
    
    public init(textWithTagModel: TKTextWithTagView.Model,
                attributedSubtitle: NSAttributedString?,
                description: String? = nil) {
      self.textWithTagModel = textWithTagModel
      self.subtitle = attributedSubtitle
      self.description = description?.withTextStyle(.body2, color: .Text.secondary, alignment: .left, lineBreakMode: .byTruncatingTail)
    }
    
    public init(textWithTagModel: TKTextWithTagView.Model,
                subtitle: String?,
                description: String? = nil) {
      self.textWithTagModel = textWithTagModel
      self.subtitle = subtitle?.withTextStyle(.body2, color: .Text.secondary, alignment: .left, lineBreakMode: .byTruncatingTail)
      self.description = description?.withTextStyle(.body2, color: .Text.secondary, alignment: .left, lineBreakMode: .byTruncatingTail)
    }
  }
  
  public func configure(model: Model) {
    textWithTagView.configure(model: model.textWithTagModel)
    
    subtitleLabel.attributedText = model.subtitle
    subtitleLabel.isHidden = model.subtitle == nil
    descriptionLabel.attributedText = model.description
    setNeedsLayout()
  }
}

private extension TKListItemTextContentView {
  func setup() {
    descriptionLabel.numberOfLines = 0
    
    addSubview(textWithTagView)
    addSubview(subtitleLabel)
    addSubview(descriptionLabel)
  }
}

