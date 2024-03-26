import UIKit

final class TKTextField: UIView {
  
  var isActive: Bool {
    textFieldInputView.isActive
  }
  
  var text: String! {
    get { textFieldInputView.text }
    set { textFieldInputView.text = newValue }
  }
  
  var didUpdateText: ((String) -> Void)?
  var didBeginEditing: (() -> Void)?
  var didEndEditing: (() -> Void)?
  
  var state: TKTextFieldState = .inactive {
    didSet {
      backgroundView.backgroundColor = state.backgroundColor
      backgroundView.layer.borderColor = state.borderColor.cgColor
      textFieldInputView.tintColor = state.tintColor
    }
  }
  
  private let backgroundView = TKTextFieldBackgroundView()
  private let textFieldInputView: TKTextFieldInputView
  
  init(textFieldInputView: TKTextFieldInputView) {
    self.textFieldInputView = textFieldInputView
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TKTextField {
  func setup() {
    textFieldInputView.didUpdateText = { [weak self] text in
      self?.didUpdateText?(text)
    }
    
    textFieldInputView.didBeginEditing = { [weak self] in
      self?.didUpdateState()
    }
    
    textFieldInputView.didEndEditing = { [weak self] in
      self?.didUpdateState()
    }
    
    addSubview(backgroundView)
    addSubview(textFieldInputView)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    backgroundView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
    
    textFieldInputView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
  }
  
  func didUpdateState() {
    let isValid = true
    switch (isActive, isValid) {
    case (false, true):
      state = .inactive
    case (true, true):
      state = .active
    case (false, false):
      state = .error
    case (true, false):
      state = .error
    }
  }
}
