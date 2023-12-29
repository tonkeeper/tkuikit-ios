import UIKit

public final class TKActionButton: TKButton<TKActionButtonContentView> {
  public typealias Model = TKButton<TKActionButtonContentView>.Model
  
  public init(size: TKActionButtonSize,
              category: TKButtonCategory) {
    super.init(
      content: TKActionButtonContentView(
        size: size, category: category
      ), 
      category: category
    )
    self.cornerRadius = size.cornerRadius
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
