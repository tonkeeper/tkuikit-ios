import UIKit

public final class TKActionButton: TKButtonContainer<TKActionButtonContentView> {
  public typealias Model = TKButtonContainer<TKActionButtonContentView>.Model
  
  public init(size: TKActionButtonSize,
              category: TKButtonCategory) {
    super.init(
      content: TKActionButtonContentView(
        size: size, category: category
      ), 
      category: category,
      cornerRadius: size.cornerRadius
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
