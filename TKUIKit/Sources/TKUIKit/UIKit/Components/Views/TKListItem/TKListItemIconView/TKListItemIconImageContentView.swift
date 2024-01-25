import UIKit

public final class TKListItemIconImageContentView: UIView, ConfigurableView {
  
  let imageView = UIImageView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public  init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView.frame = bounds
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    imageView.systemLayoutSizeFitting(targetSize)
  }
  
  public struct Model {
    public let image: UIImage
    public let tintColor: UIColor
    public let backgroundColor: UIColor
    
    public init(image: UIImage,
                tintColor: UIColor,
                backgroundColor: UIColor) {
      self.image = image
      self.tintColor = tintColor
      self.backgroundColor = backgroundColor
    }
  }
  
  public func configure(model: Model) {
    imageView.image = model.image
    imageView.tintColor = model.tintColor
    backgroundColor = model.backgroundColor
  }
}

private extension TKListItemIconImageContentView {
  func setup() {
    imageView.contentMode = .center
    addSubview(imageView)
  }
}
