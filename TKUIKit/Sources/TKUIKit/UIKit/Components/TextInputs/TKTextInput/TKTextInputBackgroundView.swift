import UIKit

public final class TKTextInputBackgroundView: UIView {
  var state: TKTextInputFieldState = .inactive {
    didSet {
      setupState()
    }
  }
  
  var isHighlighted = false {
    didSet {
      highlightView.isHighlighted = isHighlighted
    }
  }
  
  private let highlightView = TKHighlightView()
  
  public override init(frame: CGRect) {
    super.init(frame: .zero)
    setup()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    highlightView.frame = bounds
  }
}

private extension TKTextInputBackgroundView {
  func setup() {
    addSubview(highlightView)
    
    highlightView.layer.cornerRadius = .cornerRadius
    
    layer.cornerRadius = .cornerRadius
    layer.borderWidth = .borderWidth
    setupState()
  }
  
  func updateBackground() {
    backgroundColor = state.backgroundColor
  }
  
  func updateBorder() {
    layer.borderColor = state.borderColor.cgColor
  }
  
  func setupState() {
    updateBackground()
    updateBorder()
  }
}

private extension CGFloat {
  static let borderWidth: CGFloat = 1.5
  static let cornerRadius: CGFloat = 16
}
