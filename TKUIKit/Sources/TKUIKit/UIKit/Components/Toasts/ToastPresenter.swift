import UIKit

public final class ToastPresenter {
  public struct Configuration {
    public enum DismissRule {
      case none
      case `default`
      case duration(TimeInterval)
    }
    
    let title: String
    let shape: ToastView.Model.Shape
    let isActivity: Bool
    let dismissRule: DismissRule
    
    public init(title: String,
                shape: ToastView.Model.Shape = .oval,
                isActivity: Bool = false,
                dismissRule: DismissRule = .default) {
      self.title = title
      self.shape = shape
      self.isActivity = isActivity
      self.dismissRule = dismissRule
    }
  }
  
  private static var queue = [Configuration]()
  private static var isPresenting = false
  
  private static var toastWindow: UIWindow?
  private static var toastView: ToastView?
  private static var toastViewTopConstraint: NSLayoutConstraint?
  private static var dispatchItem: DispatchWorkItem?
  
  private init() {}
 
  public static func showToast(configuration: Configuration) {
    if isPresenting {
      guard let index = queue.firstIndex(where: { $0.title == configuration.title }) else {
        queue.append(configuration)
        return
      }
      
      switch index {
      case 0:
        dispatchItem?.cancel()
    
        let duration: TimeInterval
        switch configuration.dismissRule {
        case .none:
          return
        case .default:
          duration = .defaultPresentationDuration
        case .duration(let timeInterval):
          duration = timeInterval
        }
        
        let dispatchItem = DispatchWorkItem(block: {
          hideToast()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: dispatchItem)
        self.dispatchItem = dispatchItem
      default:
        return
      }
    } else {
      queue.append(configuration)
      show(configuration: configuration)
    }
  }
  
  public static func hideToast() {
    hideToastView {
      toastView?.removeFromSuperview()
      toastView = nil
      toastViewTopConstraint = nil
      isPresenting = false
      if !queue.isEmpty {
        queue.removeFirst()
      }
      showNextIfPossible()
    }
  }
  
  public static func hideAll() {
    queue.removeAll()
    hideToast()
  }

  private static func showNextIfPossible() {
    guard !queue.isEmpty else { return }
    show(configuration: queue[0])
  }
  
  private static func show(configuration: Configuration) {
    let model = ToastView.Model(title: configuration.title, shape: configuration.shape, isActivity: configuration.isActivity)
    
    let durationDismiss: (TimeInterval) -> Void = { duration in
      let dispatchItem = DispatchWorkItem(block: {
        hideToast()
      })
      DispatchQueue.main.asyncAfter(deadline: .now() + duration + .animationDuration, execute: dispatchItem)
      self.dispatchItem = dispatchItem
    }
    
    switch configuration.dismissRule {
    case .default:
      durationDismiss(.defaultPresentationDuration)
    case .duration(let timeInterval):
      durationDismiss(timeInterval)
    case .none:
      break
    }
  
    showToastView(model: model)
  }
  
  private static func hideToastView(completion: @escaping () -> Void) {
    guard let toastWindow = toastWindow,
          let toastView = toastView else { return }
    
    toastViewTopConstraint?.constant = -toastView.intrinsicContentSize.height - .hideInset
    UIView.animate(withDuration: .animationDuration,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
      toastView.alpha = 0
      toastWindow.layoutIfNeeded()
    }, completion: { _ in
      completion()
    })
  }
  
  private static func showToastView(model: ToastView.Model,
                                    completion: (() -> Void)? = nil) {
    let scene = UIApplication.keyWindowScene
    guard let scene = scene else { return }
    let toastWindow = TKPassthroughWindow(windowScene: scene)
    toastWindow.makeKeyAndVisible()
    self.toastWindow = toastWindow
    
    isPresenting = true
    
    let toastView = ToastView(model: model)
    toastView.alpha = 0
    self.toastView = toastView
    toastWindow.addSubview(toastView)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    toastView.centerXAnchor.constraint(
      equalTo: toastWindow.centerXAnchor
    ).isActive = true
    let topConstraint = toastView.topAnchor.constraint(
      equalTo: toastWindow.safeAreaLayoutGuide.topAnchor,
      constant: -toastView.intrinsicContentSize.height - .hideInset
    )
    toastViewTopConstraint = topConstraint
    topConstraint.isActive = true
    toastWindow.layoutIfNeeded()

    topConstraint.constant = 0
    UIView.animate(withDuration: .animationDuration,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
      toastView.alpha = 1
      toastWindow.layoutIfNeeded()
    }, completion: { _ in
      completion?()
    })
  }
}

private extension CGFloat {
  static let hideInset: CGFloat = 20
}

private extension TimeInterval {
  static let animationDuration: TimeInterval = 0.2
  static let defaultPresentationDuration: TimeInterval = 2.0
}

public extension UIApplication {
  static var keyWindow: UIWindow? {
    self
      .shared
      .connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.windows }
      .flatMap { $0 }
      .last { $0.isKeyWindow }
  }
  
  static var keyWindowScene: UIWindowScene? {
    self
      .keyWindow?
      .windowScene
  }
}
