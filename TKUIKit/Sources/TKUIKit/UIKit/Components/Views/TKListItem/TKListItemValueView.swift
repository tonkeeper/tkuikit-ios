import UIKit

public final class TKListItemValueView: UIView, ConfigurableView {
  
  private var valueContainerView: UIView?

  public override func layoutSubviews() {
    super.layoutSubviews()
    
    valueContainerView?.frame = bounds
  }
  
  public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    valueContainerView?.systemLayoutSizeFitting(targetSize) ?? .zero
  }
  
  public enum Model {
    case defaultValue(TKListItemDefaultValueView.Model)
  }
  
  public func configure(model: Model) {
    valueContainerView?.removeFromSuperview()
    
    switch model {
    case .defaultValue(let model):
      let view = TKListItemDefaultValueView()
      view.configure(model: model)
      addSubview(view)
      self.valueContainerView = view
    }
    setNeedsLayout()
  }
}

private extension TKListItemValueView {}

