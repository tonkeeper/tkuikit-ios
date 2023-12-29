import UIKit

public final class TKActionButtonContentView: UIView, TKButtonContainerContent {
  public var padding: UIEdgeInsets {
    size.padding
  }
  
  public var buttonState = TKButtonState.normal {
    didSet {
      setupTitle()
    }
  }

  private let titleLabel = UILabel()
  
  private var model = Model(title: "")
  
  let size: TKActionButtonSize
  let category: TKButtonCategory
  
  init(size: TKActionButtonSize,
       category: TKButtonCategory) {
    self.size = size
    self.category = category
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  // MARK: - ConfigurableView
  
  public struct Model {
    let title: String
    public init(title: String) {
      self.title = title
    }
  }
  
  public func configure(model: Model) {
    self.model = model
    setupTitle()
  }
}

private extension TKActionButtonContentView {
  func setup() {
    isUserInteractionEnabled = false
    
    addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: topAnchor).withPriority(.defaultHigh).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: leftAnchor).withPriority(.defaultHigh).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).withPriority(.defaultHigh).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: rightAnchor).withPriority(.defaultHigh).isActive = true
    
    setupTitle()
  }
  
  func setupTitle() {
    let titleColor: UIColor = {
      switch buttonState {
      case .normal:
        return category.titleColor
      case .highlighted:
        return category.titleColor
      case .disabled:
        return category.disabledTitleColor
      }
    }()

    titleLabel.attributedText = model.title.withTextStyle(
      size.textStyle,
      color: titleColor
    )
  }
}
