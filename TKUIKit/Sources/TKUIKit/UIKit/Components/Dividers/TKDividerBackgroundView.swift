import UIKit

public final class TKDividerBackgroundView: UIView {
  
  public var numberOfRows: (() -> Int)?
  public var numberOfItems: ((Int) -> Int)?
  
  private let horizontalDivider = TKHorizontalDividerView()
  private let leftVerticalDivider = TKVerticalDividerView()
  private let rightVerticalDivider = TKVerticalDividerView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    horizontalDivider.frame = CGRect(
      x: 0,
      y: bounds.height/2 - 0.5/2,
      width: bounds.width,
      height: 0.5)
    
    let sectionWidth = bounds.width/3
    leftVerticalDivider.frame = CGRect(
      x: sectionWidth,
      y: 0,
      width: 0.5,
      height: bounds.height
    )
    rightVerticalDivider.frame = CGRect(
      x: bounds.width - sectionWidth,
      y: 0,
      width: 0.5,
      height: bounds.height
    )
  }
}

private extension TKDividerBackgroundView {
  func setup() {
    addSubview(horizontalDivider)
    addSubview(leftVerticalDivider)
    addSubview(rightVerticalDivider)
  }
}

private final class TKHorizontalDividerView: UIView {
  private let solidView = UIView()
  private let leftGradientView = TKGradientView(color: .Background.content, direction: .rightToLeft)
  private let rightGradientView = TKGradientView(color: .Background.content, direction: .leftToRight)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let solidViewWidth = bounds.width * .horizontalDividerSolidToWidthAspect
    let gradientViewsWidth = solidViewWidth * .horizontalDividerGradientToSolidWidthAspect
    
    let solidViewFrame = CGRect(
      x: bounds.width/2 - solidViewWidth/2,
      y: 0,
      width: solidViewWidth,
      height: bounds.height)
    solidView.frame = solidViewFrame
    
    let leftGradientViewFrame = CGRect(
      x: solidViewFrame.minX - gradientViewsWidth,
      y: 0,
      width: gradientViewsWidth,
      height: bounds.height)
    leftGradientView.frame = leftGradientViewFrame
    
    let rightGradientViewFrame = CGRect(
      x: solidViewFrame.maxX,
      y: 0,
      width: gradientViewsWidth,
      height: bounds.height)
    rightGradientView.frame = rightGradientViewFrame
  }
  
  private func setup() {
    solidView.backgroundColor = .Background.content
    
    addSubview(solidView)
    addSubview(leftGradientView)
    addSubview(rightGradientView)
  }
}

private final class TKVerticalDividerView: UIView {
  private let solidView = UIView()
  private let topGradientView = TKGradientView(color: .Background.content, direction: .bottomToTop)
  private let bottomGradientView = TKGradientView(color: .Background.content, direction: .topToBottom)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let solidViewHeight = bounds.height * .verticalDividerSolidToWidthAspect
    let gradientViewsHeight = solidViewHeight * .verticalDividerGradientToSolidWidthAspect
    
    let solidViewFrame = CGRect(
      x: 0,
      y: bounds.height/2 - solidViewHeight/2,
      width: 0.5,
      height: solidViewHeight)
    solidView.frame = solidViewFrame
    
    let topGradientViewFrame = CGRect(
      x: 0,
      y: solidViewFrame.minY - gradientViewsHeight,
      width: 0.5,
      height: gradientViewsHeight)
    topGradientView.frame = topGradientViewFrame
    
    let bottomGradientViewFrame = CGRect(
      x: 0,
      y: solidViewFrame.maxY,
      width: 0.5,
      height: gradientViewsHeight)
    bottomGradientView.frame = bottomGradientViewFrame
  }
  
  private func setup() {
    solidView.backgroundColor = .Background.content
    
    addSubview(solidView)
    addSubview(topGradientView)
    addSubview(bottomGradientView)
  }
}

private extension CGFloat {
  static let horizontalDividerSolidToWidthAspect: CGFloat = 246/358
  static let horizontalDividerGradientToSolidWidthAspect: CGFloat = 48/246
  
  static let verticalDividerSolidToWidthAspect: CGFloat = 64/160
  static let verticalDividerGradientToSolidWidthAspect: CGFloat = 24/64
}
