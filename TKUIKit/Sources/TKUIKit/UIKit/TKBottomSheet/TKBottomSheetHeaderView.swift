import UIKit

public final class TKBottomSheetHeaderView: UIView, ConfigurableView {
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let closeButton = TKUIHeaderIconButton()
  let leftButtonContainer = UIView()
  private let titleVerticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  private let titleHoriontalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .horizontal
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
  
  public func configure(model: TKPullCardHeaderItem?) {
    guard let model = model else {
      titleLabel.text = nil
      subtitleLabel.text = nil
      leftButtonContainer.subviews.forEach { $0.removeFromSuperview() }
      return
    }
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
      leftButton.addTapAction(leftButtonModel.action)
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
    titleVerticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor).withPriority(.defaultHigh)
  }()
  lazy var titleLeftEdgeConstraint: NSLayoutConstraint = {
    titleVerticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
  }()
  lazy var titleLeftButtonConstraint: NSLayoutConstraint = {
    titleVerticalStackView.leftAnchor.constraint(greaterThanOrEqualTo: leftButtonContainer.rightAnchor)
  }()
}

private extension TKBottomSheetHeaderView {
  func setup() {
    addSubview(closeButton)
    addSubview(leftButtonContainer)
    addSubview(titleHoriontalStackView)
    
    titleHoriontalStackView.addArrangedSubview(titleVerticalStackView)
    titleVerticalStackView.addArrangedSubview(titleLabel)
    titleVerticalStackView.addArrangedSubview(subtitleLabel)
    
    closeButton.configure(
      model: TKUIHeaderButtonIconContentView.Model(image: .TKUIKit.Icons.Size16.close)
    )

    setupConstraints()
  }
  
  func setupConstraints() {
    titleHoriontalStackView.translatesAutoresizingMaskIntoConstraints = false
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    leftButtonContainer.translatesAutoresizingMaskIntoConstraints = false
    
    closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    leftButtonContainer.setContentCompressionResistancePriority(.required, for: .horizontal)

    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).withPriority(.defaultHigh),
      closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).withPriority(.defaultHigh),
      
      titleHoriontalStackView.topAnchor.constraint(equalTo: topAnchor),
      titleHoriontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).withPriority(.defaultHigh),
      titleHoriontalStackView.rightAnchor.constraint(lessThanOrEqualTo: closeButton.leftAnchor),
      titleHoriontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      leftButtonContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      leftButtonContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
    ])
  }
}
