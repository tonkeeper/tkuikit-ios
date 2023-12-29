import UIKit

public final class TKAsyncButton<Content: TKButtonContent>: UIView, ConfigurableView {
  private let button: TKButton<Content>
  private let loaderView: TKLoaderView
  private var isPerformingTask = false {
    didSet {
      didUpdateIsPerformingTask()
    }
  }
  private var isActivityViewVisible = false {
    didSet {
      didUpdateIsActivityViewVisible()
    }
  }
  
  public init(button: TKButton<Content>,
              loaderViewSize: TKLoaderView.Size) {
    self.button = button
    self.loaderView = TKLoaderView(
      size: loaderViewSize,
      style: .primary
    )
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ConfigurableView
  
  public struct Model {
    let contentModel: Content.Model
    let tapAction: () async -> Void
    
    public init(contentModel: Content.Model,
                tapAction: @escaping () async -> Void) {
      self.contentModel = contentModel
      self.tapAction = tapAction
    }
  }
  
  public func configure(model: Model) {
    let tapAction = { [weak self] in
      guard let self = self else { return }
      isPerformingTask = true
      Task {
        let activityViewTask: Task<Void, Error>? = Task {
          try await Task.sleep(nanoseconds: 150_000_000)
          await MainActor.run {
            self.isActivityViewVisible = true
          }
        }
        await model.tapAction()
        activityViewTask?.cancel()
        await MainActor.run {
          self.isActivityViewVisible = false
          self.isPerformingTask = false
        }
      }
    }
    let buttonModel = TKButton<Content>.Model(
      contentModel: model.contentModel,
      tapAction: tapAction
    )
    button.configure(model: buttonModel)
  }
}

private extension TKAsyncButton {
  func setup() {
    loaderView.alpha = 0
    addSubview(button)
    addSubview(loaderView)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    loaderView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: topAnchor),
      button.leftAnchor.constraint(equalTo: leftAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor),
      button.rightAnchor.constraint(equalTo: rightAnchor),
      
      loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  func didUpdateIsActivityViewVisible() {
    UIView.animate(withDuration: 0.2) {
      self.isActivityViewVisible ? self.showActivityView() : self.hideActivityView()
    }
  }
  
  func didUpdateIsPerformingTask() {
    isUserInteractionEnabled = !isPerformingTask
  }
  
  func showActivityView() {
    button.content.alpha = 0
    loaderView.alpha = 1
    loaderView.isLoading = true
  }
  
  func hideActivityView() {
    button.content.alpha = 1
    loaderView.alpha = 0
    loaderView.isLoading = false
  }
}
