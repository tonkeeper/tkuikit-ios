import UIKit

public enum TKListItemCollectionViewCellAccessoryType {
  case none
  case disclosureIndicator
}

public final class TKListItemCollectionViewCell: UICollectionViewCell, ConfigurableView {
  
  public var accessoryType: TKListItemCollectionViewCellAccessoryType = .none
  public var isFirst = false {
    didSet { setupCellOrder() }
  }
  public var isLast = false {
    didSet { setupCellOrder() }
  }
  
  // MARK: - Subviews
  
  let listItemView = TKListItemView()
  let highlightView = TKHighlightView()
  let accessoryView = TKListItemCollectionViewCell.AccessoryView()
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .Separator.common
    return view
  }()
  
  // MARK: - Init
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    layoutAccessoryView()
    layoutListItemView()
    layoutSeparator()
    highlightView.frame = bounds
  }
  
  private func layoutListItemView() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let listItemViewWidth: CGFloat
    switch accessoryView.mode {
    case .none:
      listItemViewWidth = contentFrame.width
    default:
      listItemViewWidth = accessoryView.frame.minX - contentFrame.minX
    }
    let listItemViewFrame = CGRect(
      origin: CGPoint(x: contentFrame.minX, y: contentFrame.minY),
      size: CGSize(width: listItemViewWidth, height: contentFrame.height)
    )
    listItemView.frame = listItemViewFrame
  }
  
  private func layoutAccessoryView() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let accessoryWidth = accessoryView.systemLayoutSizeFitting(.zero).width
    let accessoryViewFrame = CGRect(
      origin: CGPoint(x: contentFrame.maxX - accessoryWidth, y: contentFrame.minY),
      size: CGSize(width: accessoryWidth, height: contentFrame.height)
    )
    accessoryView.frame = accessoryViewFrame
  }
  
  private func layoutSeparator() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let separatorViewFrame = CGRect(x: contentFrame.minX,
                                    y: bounds.height - 0.5,
                                    width: contentFrame.width + UIEdgeInsets.contentPadding.right,
                                    height: 0.5)
    separatorView.frame = separatorViewFrame
  }
  
  // MARK: - CellConfiguration
  
  public override func updateConfiguration(using state: UICellConfigurationState) {
    highlightView.alpha = state.isHighlighted ? 1 : 0
    setupSeparator()
    
    let accessoryViewMode: TKListItemCollectionViewCell.AccessoryView.Mode
    switch (state.isEditing, state.isSelected) {
    case (true, _):
      accessoryViewMode = .reorder
    case (false, true):
      accessoryViewMode = .checkmark
    case (false, false):
      switch accessoryType {
      case .none:
        accessoryViewMode = .none
      case .disclosureIndicator:
        accessoryViewMode = .disclosureIndicator
      }
    }
    
    layoutAccessoryView()
    UIView.transition(
      with: contentView,
      duration: 0.3,
      options: [.transitionCrossDissolve, .curveEaseInOut]) {
        self.accessoryView.mode = accessoryViewMode
        self.layoutListItemView()
      }
  }
  
  // MARK: - ConfigurableView
  
  public struct Model: Hashable {
    public let identifier: String
    public let listItemModel: TKListItemView.Model
    
    public static func ==(lhs: Model, rhs: Model) -> Bool {
      lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    public init(identifier: String, listItemModel: TKListItemView.Model) {
      self.identifier = identifier
      self.listItemModel = listItemModel
    }
  }
  
  public func configure(model: Model) {
    listItemView.configure(model: model.listItemModel)
  }
  
  // MARK: - Reuse
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    isFirst = false
    isLast = false
    setupSeparator()
  }
}

private extension TKListItemCollectionViewCell {
  func setup() {
    layer.masksToBounds = true
    
    backgroundColor = .Background.content
    
    highlightView.backgroundColor = .Background.highlighted
    highlightView.alpha = 0
    
    contentView.addSubview(highlightView)
    contentView.addSubview(listItemView)
    contentView.addSubview(accessoryView)
    contentView.addSubview(separatorView)
  }
  
  func setupSeparator() {
    let isHidden = isLast || configurationState.isHighlighted
    separatorView.isHidden = isHidden
  }
  
  func setupCellOrder() {
    switch (isLast, isFirst) {
    case (true, false):
      layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      layer.cornerRadius = .cornerRadius
    case (false, true):
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      layer.cornerRadius = .cornerRadius
    case (true, true):
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                             .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      layer.cornerRadius = .cornerRadius
    case (false, false):
      layer.cornerRadius = 0
    }
    setupSeparator()
  }
}

private extension UIEdgeInsets {
  static let contentPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}
private extension CGFloat {
  static let cornerRadius: CGFloat = 16
  static let separatorhHeight: CGFloat = 0.5
}

