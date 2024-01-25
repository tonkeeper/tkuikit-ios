import UIKit

public protocol TKReorderableCell: UICollectionViewCell {
  var isReordering: Bool { get set }
}

public final class TKCollectionController: NSObject {
  public typealias Item = TKCollectionItemIdentifier
  public typealias Section = TKCollectionSection
  public typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
  public typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  
  public typealias ListItemCellRegistration = UICollectionView.CellRegistration
  <TKListItemCollectionViewCell, TKListItemCollectionViewCell.Model>
  public typealias HeaderRegistration = UICollectionView.SupplementaryRegistration
  <CollectionViewSupplementaryContainerView>
  public typealias FooterRegistration = UICollectionView.SupplementaryRegistration
  <CollectionViewSupplementaryContainerView>
  
  public var isReordering: Bool = false {
    didSet {
      collectionView.visibleCells
        .compactMap { $0 as? TKReorderableCell }
        .forEach { $0.isReordering = isReordering }
      reorderGesture.isEnabled = isReordering
    }
  }
  
  public var didReorder: ((CollectionDifference<Item>) -> Void)?
  
  private let collectionView: UICollectionView
  private let sectionPaddingProvider: (TKCollectionSection) -> NSDirectionalEdgeInsets
  private let headerViewProvider: (() -> UIView)?
  private let footerViewProvider: (() -> UIView)?
  
  private let dataSource: DataSource
  private let listItemCellRegistration: ListItemCellRegistration
  private let headerRegistration: HeaderRegistration
  private let footerRegistraation: FooterRegistration
  
  private lazy var reorderGesture: UILongPressGestureRecognizer = {
    let gesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(handleReorderGesture(gesture:))
    )
    gesture.isEnabled = false
    return gesture
  }()

  
  public init(collectionView: UICollectionView,
              sectionPaddingProvider: @escaping (TKCollectionSection) -> NSDirectionalEdgeInsets,
              headerViewProvider: (() -> UIView)? = nil,
              footerViewProvider: (() -> UIView)? = nil) {
    self.collectionView = collectionView
    self.sectionPaddingProvider = sectionPaddingProvider
    self.headerViewProvider = headerViewProvider
    self.footerViewProvider = footerViewProvider
    
    let listItemCellRegistration = ListItemCellRegistration { cell, indexPath, itemIdentifier in
      cell.configure(model: itemIdentifier)
    }
    self.listItemCellRegistration = listItemCellRegistration
    
    let headerRegistration = HeaderRegistration(elementKind: TKCollectionLayout.SupplementaryItem.header.rawValue) {
      supplementaryView, elementKind, indexPath in
      supplementaryView.setContentView(headerViewProvider?())
    }
    self.headerRegistration = headerRegistration
    
    let footerRegistration = FooterRegistration(elementKind: TKCollectionLayout.SupplementaryItem.footer.rawValue) { 
      supplementaryView, elementKind, indexPath in
      supplementaryView.setContentView(footerViewProvider?())
    }
    self.footerRegistraation = footerRegistration
    
    self.dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch itemIdentifier.model {
      case let model as TKListItemCollectionViewCell.Model:
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: listItemCellRegistration,
          for: indexPath,
          item: model)
        cell.accessoryType = itemIdentifier.accessoryViewType
        cell.isSelectable = itemIdentifier.isSelectable
        cell.isReordable = itemIdentifier.isReorderable
        cell.isFirstInSection = { $0.item == 0 }
        cell.isLastInSection = { [unowned collectionView] in
          let numberOfItems = collectionView.numberOfItems(inSection: $0.section)
          return $0.item == numberOfItems - 1
        }
        return cell
      default: return nil
      }
    })
    super.init()
    setupCollectionView()
    
    self.dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
      switch TKCollectionLayout.SupplementaryItem(rawValue: elementKind) {
      case .header:
        return collectionView.dequeueConfiguredReusableSupplementary(
          using: headerRegistration,
          for: indexPath
        )
      case .footer:
        return collectionView.dequeueConfiguredReusableSupplementary(
          using: footerRegistration,
          for: indexPath
        )
      case .none:
        return nil
      }
    }
  }
  
  public func setSections(_ sections: [TKCollectionSection], animated: Bool) {
    var snapshot = dataSource.snapshot()
    snapshot.deleteAllItems()
    
    sections.forEach { section in
      snapshot.appendSections([section])
      switch section {
      case .list(let items):
        snapshot.appendItems(items, toSection: section)
      }
    }
    dataSource.apply(snapshot, animatingDifferences: animated)
  }
}

private extension TKCollectionController {
  func setupCollectionView() {
    collectionView.delegate = self
    collectionView.addGestureRecognizer(reorderGesture)
    setupLayout()
    
    dataSource.reorderingHandlers.canReorderItem = { [weak self] item in
      guard let self = self else { return false }
      return isReordering
    }
    
    dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
      self?.didReorder?(transaction.difference)
    }
  }
  
  func setupLayout() {
    collectionView.setCollectionViewLayout(
      TKCollectionLayout.createLayout(section: { [weak self] sectionIndex -> TKCollectionSection? in
        guard let self = self else { return nil }
        
        if #available(iOS 15.0, *) {
          guard let section = self.dataSource.sectionIdentifier(for: sectionIndex) else { return nil }
          return section
        } else {
          let snapshot = self.dataSource.snapshot().sectionIdentifiers
          guard snapshot.count > sectionIndex else { return nil }
          return snapshot[sectionIndex]
        }
      }, sectionPaddingProvider: { [weak self] section in
        self?.sectionPaddingProvider(section) ?? .zero
      }),
      animated: false
    )
  }
  
  @objc
  func handleReorderGesture(gesture: UIGestureRecognizer) {
    switch(gesture.state) {
    case .began:
      guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
        break
      }
      collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
    case .changed:
      var location = gesture.location(in: gesture.view!)
      location.x = collectionView.bounds.width/2
      collectionView.updateInteractiveMovementTargetPosition(location)
    case .ended:
      collectionView.endInteractiveMovement()
    default:
      collectionView.cancelInteractiveMovement()
    }
  }
}

extension TKCollectionController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = dataSource.itemIdentifier(for: indexPath)
    item?.tapClosure?()
  }
  
  public func collectionView(_ collectionView: UICollectionView, 
                             willDisplay cell: UICollectionViewCell,
                             forItemAt indexPath: IndexPath) {
    (cell as? TKReorderableCell)?.isReordering = isReordering
  }
  
  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    !isReordering
  }
}
