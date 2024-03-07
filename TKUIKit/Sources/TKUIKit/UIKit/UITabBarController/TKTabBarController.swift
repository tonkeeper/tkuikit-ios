import UIKit
import SnapKit

public final class TKTabBarController: UITabBarController {
  private let blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    return blurView
  }()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.insertSubview(blurView, belowSubview: tabBar)
    
    blurView.snp.makeConstraints { make in
      make.edges.equalTo(tabBar)
    }
  }
}
