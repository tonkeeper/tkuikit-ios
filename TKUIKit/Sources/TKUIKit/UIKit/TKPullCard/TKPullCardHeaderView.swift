import UIKit

public final class TKPullCardHeaderView: UIView, ConfigurableView {
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let closeButton = TKUIHeaderIconButton()
  let leftButtonContainer = UIView()
  private let titleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
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
  
  public func configure(model: TKPullCardHeaderItem) {
    titleLabel.attributedText = model.title.withTextStyle(
      .h3,
      color: .Text.primary,
      alignment: .left,
      lineBreakMode: .byTruncatingTail
    )
    subtitleLabel.attributedText = model.subtitle
    
    leftButtonContainer.subviews.forEach { $0.removeFromSuperview() }
    if let leftButtonModel = model.leftButton {
      let leftButton = TKUIHeaderTitleIconButton()
      leftButton.configure(model: leftButtonModel.model)
      leftButtonContainer.addSubview(leftButton)
      leftButton.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        leftButton.topAnchor.constraint(equalTo: leftButtonContainer.topAnchor),
        leftButton.leftAnchor.constraint(equalTo: leftButtonContainer.leftAnchor),
        leftButton.bottomAnchor.constraint(equalTo: leftButtonContainer.bottomAnchor),
        leftButton.rightAnchor.constraint(equalTo: leftButtonContainer.rightAnchor)
      ])
      titleLeftEdgeConstraint.isActive = false
      titleLeftButtonConstraint.isActive = true
      titleCenterXConstraint.isActive = true
      
    } else {
      titleCenterXConstraint.isActive = false
      titleLeftButtonConstraint.isActive = false
      titleLeftEdgeConstraint.isActive = true
    }
  }
  
  lazy var titleCenterXConstraint: NSLayoutConstraint = {
    titleStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
  }()
  lazy var titleLeftEdgeConstraint: NSLayoutConstraint = {
    titleStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
  }()
  lazy var titleLeftButtonConstraint: NSLayoutConstraint = {
    titleStackView.leftAnchor.constraint(greaterThanOrEqualTo: leftButtonContainer.rightAnchor)
  }()
}

private extension TKPullCardHeaderView {
  func setup() {
    addSubview(closeButton)
    addSubview(leftButtonContainer)
    addSubview(titleStackView)
    
    titleStackView.addArrangedSubview(titleLabel)
    titleStackView.addArrangedSubview(subtitleLabel)
    
    closeButton.configure(
      model: TKUIHeaderButtonIconContentView.Model(image: .TKUIKit.Icons.Size16.close)
    )

    setupConstraints()
  }
  
  func setupConstraints() {
    titleStackView.translatesAutoresizingMaskIntoConstraints = false
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    leftButtonContainer.translatesAutoresizingMaskIntoConstraints = false
    
    closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    leftButtonContainer.setContentCompressionResistancePriority(.required, for: .horizontal)

    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
      closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).withPriority(.defaultHigh),
      
      titleStackView.topAnchor.constraint(equalTo: topAnchor),
      titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      titleStackView.rightAnchor.constraint(lessThanOrEqualTo: closeButton.leftAnchor),
      
      leftButtonContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      leftButtonContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
    ])
  }
}
