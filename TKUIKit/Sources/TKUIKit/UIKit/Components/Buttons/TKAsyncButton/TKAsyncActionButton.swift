import UIKit

public typealias TKAsyncActionButton = TKAsyncButton<TKActionButtonContentView>

extension TKAsyncActionButton {
  public convenience init(button: TKActionButton) {
    self.init(button: button, loaderViewSize: button.content.size.loaderSize)
  }
}

private extension TKActionButtonSize {
  var loaderSize: TKLoaderView.Size {
    switch self {
    case .small:
      return .small
    case .medium:
      return .medium
    case .large:
      return .medium
    }
  }
}
