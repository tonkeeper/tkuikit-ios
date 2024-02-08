import UIKit

public final class TKListTitleView: UIView, ReusableView, TKCollectionViewSupplementaryContainerViewContentView {
  
  public struct Model: Hashable {
    public let title: String?
    
    public init(title: String?) {
      self.title = title
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = TKTextStyle.h3.font
    label.textColor = .Text.primary
    label.textAlignment = .left
    return label
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: .height)
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: .height)
  }
  
  public func prepareForReuse() {
    titleLabel.text = nil
  }
  
  public func configure(model: Model) {
    titleLabel.text = model.title
  }
}

private extension TKListTitleView {
  func setup() {
    addSubview(titleLabel)
    backgroundColor = .Background.page
    
    titleLabel.backgroundColor = .Background.page
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}

private extension CGFloat {
  static let height: CGFloat = 56
}
