import UIKit

public final class TKListItemValueView: UIView, ConfigurableView {
  
  private var contentView: UIView?

  public override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView?.frame = bounds
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    contentView?.systemLayoutSizeFitting(targetSize) ?? .zero
  }
  
  public enum Model {
    case textContent(TKListItemValueTextContentView.Model)
  }
  
  public func configure(model: Model) {
    contentView?.removeFromSuperview()
    
    switch model {
    case .textContent(let model):
      let view = TKListItemValueTextContentView()
      view.configure(model: model)
      addSubview(view)
      self.contentView = view
    }
    setNeedsLayout()
  }
}

private extension TKListItemValueView {}

