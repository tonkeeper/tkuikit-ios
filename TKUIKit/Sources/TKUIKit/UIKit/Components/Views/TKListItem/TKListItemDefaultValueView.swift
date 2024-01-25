import UIKit

public final class TKListItemDefaultValueView: UIView, ConfigurableView {
  
  let valueContainerView = UIView()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    valueContainerView.frame = bounds
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    valueContainerView.systemLayoutSizeFitting(targetSize)
  }
  
  public struct Model {
    
//    public let textWithTagModel: TKTextWithTagView.Model
//    public let subtitle: NSAttributedString?
//
//    public init(textWithTagModel: TKTextWithTagView.Model,
//                attributedSubtitle: NSAttributedString?) {
//      self.textWithTagModel = textWithTagModel
//      self.subtitle = attributedSubtitle
//    }
//
//    public init(textWithTagModel: TKTextWithTagView.Model,
//                subtitle: String?) {
//      self.textWithTagModel = textWithTagModel
//      self.subtitle = subtitle?.withTextStyle(.body2, color: .Text.secondary, alignment: .left, lineBreakMode: .byTruncatingTail)
//    }
  }
  
  public func configure(model: Model) {
    //    textWithTagView.configure(model: model.textWithTagModel)
    //
    //    subtitleLabel.attributedText = model.subtitle
    //    subtitleLabel.isHidden = model.subtitle == nil
    setNeedsLayout()
  }
}

private extension TKListItemDefaultValueView {
  func setup() {
    addSubview(valueContainerView)
  }
}

