import UIKit
import SnapKit

protocol SignInViewProtocol: AnyObject {
    func signUpLabelTapped()
    func signInButtonTapped()
}

final class SignInView: UIView {
    private lazy var welcomeCustomeLabel = UICustomLabel(
        labelText: Strings.discountekaIsAPersonSBestFriend,
        alignment: .center)
    private lazy var emailCustomTextField = UICustomTextField(placeholderText: Strings.email)
    private lazy var passwordCustomTextField = UICustomTextField(placeholderText: Strings.password)
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.donTYouHaveAnAccountYet
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.hexStringToUIColor(hex: "DBD7D7")
        return label
    }()

    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.signUp
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.hexStringToUIColor(hex: "2B83FF")
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var textFieldsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailCustomTextField, passwordCustomTextField])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var signUpInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel, signUpLabel])
        stack.spacing = 2
        stack.axis = .horizontal
        stack.contentMode = .center
        return stack
    }()

    private lazy var signUpCustomButton: UICustomButton = {
        let button = UICustomButton(Strings.signIn)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.signInButtonTapped()
        }, for: .touchUpInside)
        return button
    }()

    weak var delegate: SignInViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTextFields()
        setupGesture()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SignInView {
    func setupLayout() {
        backgroundColor = UIColor(named: "backgroundColor")
        addSubview(welcomeCustomeLabel)
        addSubview(textFieldsStack)
        addSubview(signUpCustomButton)
        addSubview(signUpInfoStack)

        welcomeCustomeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        textFieldsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        signUpCustomButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
        signUpInfoStack.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(signUpCustomButton.snp.bottom).offset(8)
        }
    }

    func setupGesture() {
        let signUpLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLableTap))
        signUpLabel.addGestureRecognizer(signUpLabelTapGesture)
    }

    @objc func handleLableTap(sender: UITapGestureRecognizer) {
        delegate?.signUpLabelTapped()
    }

    func setupTextFields() {
        passwordCustomTextField.isSecureTextEntry = true
        emailCustomTextField.autocapitalizationType = .none
        passwordCustomTextField.textContentType = .password
        emailCustomTextField.textContentType = .emailAddress

        emailCustomTextField.externalDelegate = self
        passwordCustomTextField.externalDelegate = self

        emailCustomTextField.returnKeyType = .next
        passwordCustomTextField.returnKeyType = .done

        emailCustomTextField.addTarget(self, action: #selector(textFieldShouldReturn(_:)), for: .editingDidEndOnExit)
        passwordCustomTextField.addTarget(self, action: #selector(textFieldShouldReturn(_:)), for: .editingDidEndOnExit)
    }
}

extension SignInView: UITextFieldDelegate {
    func configureSignInForm() -> (String?, String?)? {
        let email = emailCustomTextField.isEmptyTextField()
        let password = passwordCustomTextField.isEmptyTextField()
        if email || password {
            return nil
        }
        return (emailCustomTextField.text, passwordCustomTextField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailCustomTextField:
            passwordCustomTextField.becomeFirstResponder()
        case passwordCustomTextField:
            textField.resignFirstResponder()
            delegate?.signInButtonTapped()
        default:
            break
        }
        return true
    }
}
