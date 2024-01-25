import UIKit

extension TKListItemCollectionViewCell {
  final class AccessoryView: UIView {
    enum Mode {
      case none
      case checkmark
      case disclosureIndicator
      case reorder
      
      var image: UIImage? {
        switch self {
        case .none: return nil
        case .checkmark: return .TKUIKit.Icons.Size28.donemarkOutline
        case .disclosureIndicator: return .TKUIKit.Icons.Size16.chevronRight
        case .reorder: return .TKUIKit.Icons.Size28.reorder
        }
      }
      
      var tintColor: UIColor? {
          switch self {
          case .none: return nil
          case .checkmark: return .Accent.blue
          case .disclosureIndicator: return .Icon.tertiary
          case .reorder: return .Icon.secondary
          }
      }
    }
    
    var mode: Mode = .none {
      didSet {
        imageView.image = mode.image
        imageView.tintColor = mode.tintColor
        setNeedsLayout()
      }
    }

    private let imageView = UIImageView()
    
    init() {
      super.init(frame: .zero)
      setup()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      imageView.frame = CGRect(x: 16, y: 0, width: bounds.width - .leftPadding, height: bounds.height)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
      let width = mode == .none ? 0 : imageView.systemLayoutSizeFitting(.zero).width + .leftPadding
      return CGSize(width: width, height: targetSize.height)
    }
  }
}

private extension TKListItemCollectionViewCell.AccessoryView {
  func setup() {
    imageView.contentMode = .left
    addSubview(imageView)
  }
}

private extension CGFloat {
  static let leftPadding: CGFloat = 16
}
