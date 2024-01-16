import UIKit

public struct TKPullCardHeaderItem {
  public struct LeftButton {
    let model: TKUIHeaderTitleIconButton.Model
    let action: (() -> Void)?
    
    public init(model: TKUIHeaderTitleIconButton.Model, action: (() -> Void)?) {
      self.model = model
      self.action = action
    }
  }
  
  let title: String
  let subtitle: NSAttributedString?
  let leftButton: LeftButton?
  
  public init(title: String,
              subtitle: NSAttributedString? = nil,
              leftButton: LeftButton? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.leftButton = leftButton
  }
  
  public init(title: String,
              subtitle: String,
              leftButton: LeftButton? = nil) {
    let attributedSubtitle = subtitle.withTextStyle(.body2, color: .Text.secondary, alignment: .left)
    self.init(title: title,
              subtitle: attributedSubtitle,
              leftButton: leftButton)
  }
}

public protocol TKPullCardContent: UIViewController {
  var didUpdateHeight: (() -> Void)? { get set }
  
  var headerItem: TKPullCardHeaderItem { get }
  var didUpdatePullCardHeaderItem: ((TKPullCardHeaderItem) -> Void)? { get set }
  
  func contentHeight(withWidth width: CGFloat) -> CGFloat
}

public extension TKPullCardContent {
  var didUpdatePullCardHeaderItem: ((TKPullCardHeaderItem) -> Void)? { nil }
}

public protocol TKPullCardScrollableContent: TKPullCardContent {
  var scrollView: UIScrollView { get }
}
