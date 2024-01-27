import UIKit

extension UIConfigurationStateCustomKey {
  static let isReordering = UIConfigurationStateCustomKey("com.tonapps.tonkeeper.TKListItemCollectionViewCell.isReordering")
}

extension UICellConfigurationState {
  var isReordering: Bool {
    get { return self[.isReordering] as? Bool ?? false }
    set { self[.isReordering] = newValue }
  }
}

public enum TKListItemCollectionViewCellAccessoryType {
  case none
  case disclosureIndicator
}

public final class TKListItemCollectionViewCell: UICollectionViewCell, ConfigurableView, ReusableView, TKReorderableCell {
  
  public var accessoryType: TKListItemCollectionViewCellAccessoryType = .none {
    didSet {
      switch accessoryType {
      case .none:
        accessoryView.mode = .none
      case .disclosureIndicator:
        accessoryView.mode = .disclosureIndicator
      }
    }
  }
  public var isSelectable: Bool = false {
    didSet {
      selectionAccessoryView.isHidden = !isSelectable
    }
  }
  public var isReordable: Bool = false {
    didSet {
      editingAccessoryView.isHidden = !isReordable
    }
  }
  
  public var isFirstInSection: ((IndexPath) -> Bool) = { _ in false }
  public var isLastInSection: ((IndexPath) -> Bool) =  { _ in false }
  
  public var isReordering: Bool = false {
    didSet {
      guard oldValue != isReordering else { return }
      setNeedsUpdateConfiguration()
    }
  }
  
  // MARK: - Subviews
  
  let listItemView = TKListItemView()
  let highlightView = TKHighlightView()
  let accessoryView = TKListItemCollectionViewCell.AccessoryView()
  let editingAccessoryView: TKListItemCollectionViewCell.AccessoryView = {
    let view = TKListItemCollectionViewCell.AccessoryView()
    view.mode = .reorder
    return view
  }()
  let selectionAccessoryView: TKListItemCollectionViewCell.AccessoryView = {
    let view = TKListItemCollectionViewCell.AccessoryView()
    view.mode = .checkmark
    return view
  }()
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .Separator.common
    return view
  }()
  
  // MARK: - State
  
  private var isSeparatorVisible: Bool = false
  
  // MARK: - Init
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let modifiedAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
    
    let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
    let contentFrame = targetSize.inset(by: .contentPadding)
    
    let listItemViewTargetWidth: CGFloat
    switch accessoryType {
    case .none:
      listItemViewTargetWidth = contentFrame.width
    case .disclosureIndicator:
      listItemViewTargetWidth = contentFrame.width - accessoryView.systemLayoutSizeFitting(.zero).width
    }
    
    let listItemViewSize = listItemView.systemLayoutSizeFitting(CGSize(width: listItemViewTargetWidth, height: 0))
    
    let resultSize = listItemViewSize.padding(by: .contentPadding)
    modifiedAttributes.frame.size.height = resultSize.height
    
    let isFirstInSection = isFirstInSection(layoutAttributes.indexPath)
    let isLastInSection = isLastInSection(layoutAttributes.indexPath)
    setupCornerRadius(isFirstInSection: isFirstInSection, isLastInSection: isLastInSection)
    isSeparatorVisible = !isLastInSection
    setupSeparator()
    
    return modifiedAttributes
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    layoutAccessoryView()
    layoutSelectionAccessoryView()
    layoutEditingAccessoryView()
    layoutListItemView()
    layoutSeparator()
    highlightView.frame = bounds
  }
  
  // MARK: - CellConfiguration
  
  public override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.isReordering = self.isReordering
    return state
  }
  
  public override func updateConfiguration(using state: UICellConfigurationState) {
    highlightView.alpha = state.isHighlighted ? 1 : 0
    
    let isReordering = state.isReordering
    let isSelected = state.isSelected && isSelectable
    switch (isReordering, isSelected) {
    case (true, _):
      editingAccessoryView.alpha = 1
      selectionAccessoryView.alpha = 0
    case (false, true):
      editingAccessoryView.alpha = 0
      selectionAccessoryView.alpha = 1
    case (false, false):
      editingAccessoryView.alpha = 0
      selectionAccessoryView.alpha = 0
    }
    layoutListItemView()
  }
  
  public func configure(model: TKListItemView.Model) {
    listItemView.configure(model: model)
    setNeedsLayout()
  }
  
  // MARK: - Reuse
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    isFirstInSection = { _ in false }
    isLastInSection = { _ in false }
    listItemView.prepareForReuse()
  }
}

private extension TKListItemCollectionViewCell {
  func setup() {
    layer.cornerRadius = .cornerRadius
    backgroundColor = .Background.content
    
    highlightView.backgroundColor = .Background.highlighted
    highlightView.alpha = 0
    
    selectionAccessoryView.alpha = 0
    editingAccessoryView.alpha = 0
    
    contentView.addSubview(highlightView)
    contentView.addSubview(listItemView)
    contentView.addSubview(accessoryView)
    contentView.addSubview(editingAccessoryView)
    contentView.addSubview(selectionAccessoryView)
    contentView.addSubview(separatorView)
  }
  
  func setupSeparator() {
    let isHidden = !isSeparatorVisible || configurationState.isHighlighted
    separatorView.isHidden = isHidden
  }
  
  func setupCornerRadius(isFirstInSection: Bool, isLastInSection: Bool) {
    let maskedCorners: CACornerMask
    let isMasksToBounds: Bool
    switch (isFirstInSection, isLastInSection) {
    case (true, true):
      maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      isMasksToBounds = true
    case (false, true):
      maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      isMasksToBounds = true
    case (true, false):
      maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      isMasksToBounds = true
    case (false, false):
      maskedCorners = []
      isMasksToBounds = false
    }
    layer.maskedCorners = maskedCorners
    layer.masksToBounds = isMasksToBounds
  }
  
  func didUpdateReorderingSelectedState() {
    switch (isReordering, isSelected) {
    case (true, _):
      editingAccessoryView.alpha = 1
      selectionAccessoryView.alpha = 0
      accessoryView.alpha = 0
    case (false, true):
      editingAccessoryView.alpha = 0
      selectionAccessoryView.alpha = 1
      accessoryView.alpha = 0
    case (false, false):
      editingAccessoryView.alpha = 0
      selectionAccessoryView.alpha = 0
      accessoryView.alpha = 1
    }
    layoutListItemView()
  }
  
  func layoutAccessoryView() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let accessoryWidth = accessoryView.systemLayoutSizeFitting(.zero).width
    let accessoryViewFrame = CGRect(
      origin: CGPoint(x: contentFrame.maxX - accessoryWidth, y: contentFrame.minY),
      size: CGSize(width: accessoryWidth, height: contentFrame.height)
    )
    accessoryView.frame = accessoryViewFrame
  }
  
  func layoutSelectionAccessoryView() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let accessoryWidth = selectionAccessoryView.systemLayoutSizeFitting(.zero).width
    let accessoryViewFrame = CGRect(
      origin: CGPoint(x: contentFrame.maxX - accessoryWidth, y: contentFrame.minY),
      size: CGSize(width: accessoryWidth, height: contentFrame.height)
    )
    selectionAccessoryView.frame = accessoryViewFrame
  }
  
  func layoutEditingAccessoryView() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let accessoryWidth = editingAccessoryView.systemLayoutSizeFitting(.zero).width
    let accessoryViewFrame = CGRect(
      origin: CGPoint(x: contentFrame.maxX - accessoryWidth, y: contentFrame.minY),
      size: CGSize(width: accessoryWidth, height: contentFrame.height)
    )
    editingAccessoryView.frame = accessoryViewFrame
  }
  
  func layoutListItemView() {
    let contentFrame = self.contentView.bounds.inset(by: .contentPadding)
    let listItemViewWidth: CGFloat
    
    let isReordering = configurationState.isReordering
    let isSelected = configurationState.isSelected && isSelectable

    switch (isReordering, isSelected) {
    case (true, _):
      listItemViewWidth = contentFrame.width - editingAccessoryView.bounds.width
    case (false, true):
      listItemViewWidth = contentFrame.width - selectionAccessoryView.bounds.width
    case (false, false):
      listItemViewWidth = contentFrame.width - accessoryView.bounds.width
    }
    let listItemViewFrame = CGRect(
      origin: contentFrame.origin,
      size: CGSize(width: listItemViewWidth, height: contentFrame.height)
    )
    self.listItemView.frame = listItemViewFrame
  }
  
  func layoutSeparator() {
    let contentFrame = contentView.bounds.inset(by: .contentPadding)
    let separatorViewFrame = CGRect(x: contentFrame.minX,
                                    y: bounds.height - 0.5,
                                    width: contentFrame.width + UIEdgeInsets.contentPadding.right,
                                    height: 0.5)
    separatorView.frame = separatorViewFrame
  }
}

private extension UIEdgeInsets {
  static let contentPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}
private extension CGFloat {
  static let cornerRadius: CGFloat = 16
  static let separatorhHeight: CGFloat = 0.5
}

