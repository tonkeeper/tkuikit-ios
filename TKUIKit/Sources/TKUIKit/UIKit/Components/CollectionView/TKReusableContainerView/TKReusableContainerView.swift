import UIKit

public final class TKReusableContainerView: UICollectionReusableView, ReusableView {
  private var contentView: UIView?
  
  public func setContentView(_ contentView: UIView?) {
    contentView?.removeFromSuperview()
    guard let contentView else { return }
    addSubview(contentView)
    
    contentView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
  }
}
