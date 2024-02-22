import UIKit

public final class TKListTitleView: UIView, ReusableView, TKCollectionViewSupplementaryContainerViewContentView {
  
  public var didTapButton: (() -> Void)?
  
  public struct Model: Hashable {
    public let title: String?
    public let buttonModel: TKButton.Model?
    
    public init(title: String?, buttonModel: TKButton.Model? = nil) {
      self.title = title
      self.buttonModel = buttonModel
    }
  }
  
  public let titleLabel: UILabel = {
    let label = UILabel()
    label.font = TKTextStyle.h3.font
    label.textColor = .Text.primary
    label.textAlignment = .left
    return label
  }()
  
  private let button = TKHeaderButton()
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    return stackView
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
    if let buttonModel = model.buttonModel {
      button.configure(model: buttonModel)
      button.isHidden = false
    } else {
      button.isHidden = true
    }
  }
}

private extension TKListTitleView {
  func setup() {
    
    button.setTapAction { [weak self] in
      self?.didTapButton?()
    }
    
    addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(button)
    backgroundColor = .Background.page
    
    titleLabel.backgroundColor = .Background.page
    
    button.setContentHuggingPriority(.required, for: .horizontal)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor)
    ])
  }
}

private extension CGFloat {
  static let height: CGFloat = 56
}
