import UIKit

public final class TKListItemIconView: UIView, ConfigurableView, ReusableView {
  
  private var contentView: ReusableView?
  
  private var alignment: Model.Alignment = .top
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let size = contentView?.systemLayoutSizeFitting(bounds.size) ?? .zero
    let frame: CGRect
    switch alignment {
    case .top:
      frame = CGRect(origin: .zero, size: size)
    case .center:
      frame = CGRect(origin: CGPoint(x: 0, y: bounds.height/2 - size.height/2), size: size)
    }
    contentView?.frame = frame
    
    contentView?.layer.cornerRadius = size.height/2
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    contentView?.systemLayoutSizeFitting(targetSize) ?? .zero
  }
  
  public func prepareForReuse() {
    contentView?.prepareForReuse()
  }

  public struct Model {
    public enum IconType {
      case emoji(model: TKListItemIconEmojiContentView.Model)
      case image(model: TKListItemIconImageContentView.Model)
      case asyncImage(model: TKListItemIconAsyncImageContentView.Model)
    }
    
    public enum Alignment {
      case top
      case center
    }
    
    public let type: IconType
    public let alignment: Alignment
    
    public init(type: IconType,
                alignment: Alignment = .top) {
      self.type = type
      self.alignment = alignment
    }
  }
  
  public func configure(model: Model) {
    self.contentView?.removeFromSuperview()
    let contentView: ReusableView = {
      switch model.type {
      case let .emoji(emojiModel):
        let view = TKListItemIconEmojiContentView()
        view.configure(model: emojiModel)
        return view
      case let .image(imageModel):
        let view = TKListItemIconImageContentView()
        view.configure(model: imageModel)
        return view
      case let .asyncImage(model):
        let view = TKListItemIconAsyncImageContentView()
        view.configure(model: model)
        return view
      }
    }()
    contentView.layer.masksToBounds = true
    addSubview(contentView)
    self.contentView = contentView
    self.alignment = model.alignment
  }
}

private extension TKListItemIconView {
  func setup() {
    layer.masksToBounds = true
  }
}

