import UIKit

final class TKButtonBackgroundView: UIView {
  var category: TKButtonCategory {
    didSet {
      setupBackground()
    }
  }
  var cornerRadius: CGFloat = 0 {
    didSet {
      setupCornerRadius()
    }
  }
  var state: TKButtonState = .normal {
    didSet {
      setupBackground()
    }
  }
  
  private let maskLayer = CAShapeLayer()
  
  init(category: TKButtonCategory) {
    self.category = category
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupCornerRadius()
  }
}

private extension TKButtonBackgroundView {
  func setup() {
    isUserInteractionEnabled = false
    
    setupBackground()
  }
  
  func setupCornerRadius() {
    maskLayer.frame = bounds
    maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    layer.mask = maskLayer
  }
  
  func setupBackground() {
    let backgroundColor: UIColor = {
      switch state {
      case .normal:
        return category.backgroundColor
      case .highlighted:
        return category.highlightedBackgroundColor
      case .disabled:
        return category.disabledBackgroundColor
      }
    }()

    self.backgroundColor = backgroundColor
  }
}
