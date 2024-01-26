import UIKit

public struct TKCollectionLayout {
  public enum SupplementaryItem: String {
    case header = "TKCollectionLayout.SupplementaryItem.Header"
    case footer = "TKCollectionLayout.SupplementaryItem.Footer"
  }
  
  public static func createLayout(section: @escaping (Int) -> TKCollectionSection?,
                           sectionPaddingProvider: @escaping (TKCollectionSection) -> NSDirectionalEdgeInsets) -> UICollectionViewLayout {
    let header = createHeaderSupplementaryItem()
    let footer = createFooterSupplementaryItem()
    
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .vertical
    configuration.boundarySupplementaryItems = [header, footer]
    
    let layout = UICollectionViewCompositionalLayout(
      sectionProvider: sectionProvider(section: section, sectionPaddingProvider: sectionPaddingProvider),
      configuration: configuration
    )
    
    return layout
  }
  
  static func sectionProvider(section: @escaping (Int) -> TKCollectionSection?,
                              sectionPaddingProvider: @escaping (TKCollectionSection) -> NSDirectionalEdgeInsets) -> UICollectionViewCompositionalLayoutSectionProvider {
    return { sectionIndex, environment in
      guard let section = section(sectionIndex) else {
        return nil
      }
      let padding = sectionPaddingProvider(section)
      return createSectionLayout(section: section, sectionPadding: padding)
    }
  }
  
  static func createSectionLayout(section: TKCollectionSection, sectionPadding: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
    switch section {
    case .list:
      return createListSectionLayout(sectionPadding: sectionPadding)
    }
  }
  
  static func createListSectionLayout(sectionPadding: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
    let itemLayoutSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(76)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
    
    let groupLayoutSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(76)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupLayoutSize, 
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = sectionPadding
    return section
  }
  
  static func createHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    let size = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(0)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: size,
      elementKind: SupplementaryItem.header.rawValue,
      alignment: .top
    )
    return header
  }
  
  static func createFooterSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    let size = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(0)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: size,
      elementKind: SupplementaryItem.footer.rawValue,
      alignment: .bottom
    )
    return header
  }
}
