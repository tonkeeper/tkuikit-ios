import UIKit

public final class TKListItemIconAsyncImageContentView: UIView, ConfigurableView, ReusableView {
  
  let imageView = UIImageView()

  private var imageProvider: ((UIImageView, CGSize) async throws -> Void)?
  private var task: Task<Void, Never>?
  
  private var cachedSize: CGSize = .zero
  
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
    
    if bounds.size != cachedSize && imageProvider != nil {
      cachedSize = bounds.size
      task = Task {
        try? await imageProvider?(imageView, bounds.size)
      }
    }
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    CGSize(width: 44, height: 44)
  }
  
  public func prepareForReuse() {
    task?.cancel()
    task = nil
  }
  
  public struct Model {
    public let imageProvider: ((UIImageView, CGSize) async throws -> Void)
    public let tintColor: UIColor
    public let backgroundColor: UIColor
    
    public init(imageProvider: @escaping ((UIImageView, CGSize) async throws -> Void),
                tintColor: UIColor,
                backgroundColor: UIColor) {
      self.imageProvider = imageProvider
      self.tintColor = tintColor
      self.backgroundColor = backgroundColor
    }
  }
  
  public func configure(model: Model) {
    imageView.tintColor = model.tintColor
    backgroundColor = model.backgroundColor
    imageProvider = model.imageProvider
  }
}

private extension TKListItemIconAsyncImageContentView {
  func setup() {
    imageView.contentMode = .center
    addSubview(imageView)
  }
}
