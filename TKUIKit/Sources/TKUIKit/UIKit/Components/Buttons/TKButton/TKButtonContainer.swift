import UIKit

public protocol TKButtonContainerContent: UIView, ConfigurableView {
  var padding: UIEdgeInsets { get }
  var buttonState: TKButtonState { get set }
}

public class TKButtonContainer<Content: TKButtonContainerContent>: UIControl, ConfigurableView {
  private let backgroundView: TKButtonBackgroundView
  
  private var tapAction: (() -> Void)?
  
  private var buttonState: TKButtonState = .normal {
    didSet {
      setupState()
    }
  }
  
  public override var isHighlighted: Bool {
    didSet {
      guard isHighlighted != oldValue else { return }
      didUpdateIsHighlightedOrIsEnabled()
    }
  }
  
  public override var isEnabled: Bool {
    didSet {
      guard isEnabled != oldValue else { return }
      didUpdateIsHighlightedOrIsEnabled()
    }
  }
  
  let content: Content
  let category: TKButtonCategory
  
  init(content: Content,
       category: TKButtonCategory,
       cornerRadius: CGFloat) {
    self.content = content
    self.category = category
    self.backgroundView = TKButtonBackgroundView(
      category: category,
      cornerRadius: cornerRadius
    )
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    backgroundView.frame = bounds
  }
  
  // MARK: - ConfigurableView
  
  public struct Model {
    let contentModel: Content.Model
    let tapAction: () -> Void
    
    public init(contentModel: Content.Model, 
                tapAction: @escaping () -> Void) {
      self.contentModel = contentModel
      self.tapAction = tapAction
    }
  }
  
  public func configure(model: Model) {
    content.configure(model: model.contentModel)
    tapAction = model.tapAction
  }
  
  @objc
  private func touchUpInsideAction() {
    tapAction?()
  }
}

private extension TKButtonContainer {
  func setup() {
    addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
    
    addSubview(backgroundView)
    setupContent()
    setupState()
  }
  
  func setupContent() {
    addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false
    content.topAnchor.constraint(
      equalTo: topAnchor,
      constant: content.padding.top
    ).withPriority(.defaultHigh).isActive = true
    content.leftAnchor.constraint(
      equalTo: leftAnchor,
      constant: content.padding.left
    ).withPriority(.defaultHigh).isActive = true
    content.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -content.padding.bottom
    ).withPriority(.defaultHigh).isActive = true
    content.rightAnchor.constraint(
      equalTo: rightAnchor,
      constant: -content.padding.right
    ).withPriority(.defaultHigh).isActive = true
  }
  
  func setupState() {
    backgroundView.state = buttonState
    content.buttonState = buttonState
  }
  
  func didUpdateIsHighlightedOrIsEnabled() {
    switch (isHighlighted, isEnabled) {
    case (false, false):
      buttonState = .disabled
    case (true, false):
      buttonState = .disabled
    case (false, true):
      buttonState = .normal
    case (true, true):
      buttonState = .highlighted
    }
  }
}
