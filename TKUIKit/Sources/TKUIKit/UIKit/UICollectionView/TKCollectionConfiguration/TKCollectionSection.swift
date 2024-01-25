import Foundation

public struct TKCollectionItemIdentifier: Hashable {
  let identifier: String
  let isSelectable: Bool
  let isReorderable: Bool
  let accessoryViewType: TKListItemCollectionViewCellAccessoryType
  let model: Any
  let tapClosure: (() -> Void)?
  
  public static func ==(lhs: TKCollectionItemIdentifier, rhs: TKCollectionItemIdentifier) -> Bool {
    return lhs.identifier == rhs.identifier
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  public init(identifier: String, 
              isSelectable: Bool,
              isReorderable: Bool,
              accessoryViewType: TKListItemCollectionViewCellAccessoryType = .none,
              model: Any,
              tapClosure: (() -> Void)?) {
    self.identifier = identifier
    self.isSelectable = isSelectable
    self.isReorderable = isReorderable
    self.accessoryViewType = accessoryViewType
    self.model = model
    self.tapClosure = tapClosure
  }
}

public enum TKCollectionSection: Hashable {
  case list(items: [TKCollectionItemIdentifier])
}
