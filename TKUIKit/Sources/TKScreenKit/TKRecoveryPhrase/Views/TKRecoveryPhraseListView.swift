import UIKit
import TKUIKit

public final class TKRecoveryPhraseListView: UIView, ConfigurableView {

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 40
    return stackView
  }()

  private let leftColumnStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()

  private let rightColumnStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ConfigurableView

  public struct Model {
    let wordModels: [TKRecoveryPhraseItemView.Model]
    
    public init(wordModels: [TKRecoveryPhraseItemView.Model]) {
      self.wordModels = wordModels
    }
  }

  public func configure(model: Model) {
    leftColumnStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    rightColumnStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    let halfIndex = Int((Float(model.wordModels.count) / 2).rounded(.up))
    let leftWords = model.wordModels[0..<halfIndex]
    let rightWords = model.wordModels[halfIndex..<model.wordModels.count]

    leftWords.forEach {
      let view = TKRecoveryPhraseItemView()
      view.configure(model: $0)
      leftColumnStackView.addArrangedSubview(view)
    }

    rightWords.forEach {
      let view = TKRecoveryPhraseItemView()
      view.configure(model: $0)
      rightColumnStackView.addArrangedSubview(view)
    }
  }
}

private extension TKRecoveryPhraseListView {
  func setup() {
    addSubview(stackView)
    stackView.addArrangedSubview(leftColumnStackView)
    stackView.addArrangedSubview(rightColumnStackView)

    setupConstraints()
  }

  func setupConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: topAnchor, constant: UIEdgeInsets.stackViewSideInsets.top
      ),
      stackView.leftAnchor.constraint(
        equalTo: leftAnchor, constant: UIEdgeInsets.stackViewSideInsets.left
      ),
      stackView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -UIEdgeInsets.stackViewSideInsets.bottom
      )
      .withPriority(.defaultHigh),
      stackView.rightAnchor.constraint(
        equalTo: rightAnchor, constant: -UIEdgeInsets.stackViewSideInsets.right
      )
      .withPriority(.defaultHigh)
    ])
  }
}

private extension UIEdgeInsets {
  static var stackViewSideInsets: UIEdgeInsets {
    .init(top: 0, left: 24, bottom: 0, right: 24)
  }
}

