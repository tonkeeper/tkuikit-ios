import UIKit

public final class TKUIButtonTitleIconContentView: UIView, ConfigurableView, TKUIButtonContentView {
  
  let stackView = UIStackView()
  let titleLabel = UILabel()
  let iconImageView = UIImageView()
  
  public let textStyle: TKTextStyle
  
  init(textStyle: TKTextStyle) {
    self.textStyle = textStyle
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public struct Model {
    public struct Icon {
      public let icon: UIImage
      public let position: IconPosition
      public init(icon: UIImage, position: IconPosition) {
        self.icon = icon
        self.position = position
      }
    }
    public enum IconPosition {
      case left
      case right
    }
    public let title: String?
    public let icon: Icon?
    public init(title: String?, icon: Icon?) {
      self.title = title
      self.icon = icon
    }
  }
  
  public var model = Model(title: nil, icon: nil)
  
  public func configure(model: Model) {
    self.model = model
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    if let title = model.title {
      stackView.addArrangedSubview(titleLabel)
      titleLabel.text = title
      titleLabel.attributedText = title.withTextStyle(
        textStyle,
        color: UIColor.Button.primaryForeground,
        alignment: .center
      )
    }
    if let icon = model.icon {
      switch icon.position {
      case .left:
        stackView.insertArrangedSubview(iconImageView, at: 0)
      case .right:
        stackView.addArrangedSubview(iconImageView)
      }
      iconImageView.image = icon.icon
    }
  }
  
  public func setForegroundColor(_ color: UIColor) {
    titleLabel.attributedText = model.title?.withTextStyle(
      textStyle,
      color: color,
      alignment: .center
    )
    iconImageView.tintColor = color
  }
}

private extension TKUIButtonTitleIconContentView {
  func setup() {
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 8
    
    iconImageView.contentMode = .center
    
    addSubview(stackView)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}
