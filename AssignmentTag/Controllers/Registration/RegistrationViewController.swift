//
//  RegistrationViewController.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 06/02/22.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var customErrorMessage: UIView?
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var userNameTextfield: CustomTextField?
    @IBOutlet weak var confirmPasswordTextfield: CustomTextField?
    @IBOutlet weak var registerButton: UIButton?
    @IBOutlet weak var passwordTextField: CustomTextField?
    
    var viewModel = RegistrationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /// Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Button Setup
    func buttonSetup() {
        registerButton?.configure(30, borderColor: .black)
    }
    
    /// Funciton to setup UI
    func setupUI() {
        customErrorMessage?.isHidden = true
        setUpTextfields()
        loadCustomErrorView()
        buttonSetup()
    }
    
    /// Funciton to setup textinputs
    func setUpTextfields() {
        userNameTextfield?.placeHolderLabel.text = Constants.username
        passwordTextField?.placeHolderLabel.text = Constants.password
        confirmPasswordTextfield?.placeHolderLabel.text = Constants.confirmPassword
        userNameTextfield?.textField.delegate = self
        passwordTextField?.textField.delegate = self
        confirmPasswordTextfield?.textField.delegate = self
        userNameTextfield?.textField.returnKeyType = .next
        passwordTextField?.textField.isSecureTextEntry = true
        confirmPasswordTextfield?.textField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /// Load ErrorView
    func loadCustomErrorView() {
        customErrorMessage?.addViewBorder(borderColor: UIColor.red.cgColor,
                                         borderWith: 1.2,
                                         borderCornerRadius: 12.0)
    }
    
    /// Clear error message
    func clearErrorMessage() {
        userNameTextfield?.errorString = nil
        passwordTextField?.errorString = nil
        confirmPasswordTextfield?.errorString = nil
    }
    
    private func performAPICall() {
        LoadingView.show()
        let request = SignUpRequestModel(username: userNameTextfield?.textField.text ?? "", password: passwordTextField?.textField.text ?? "")
        viewModel.signup(request) { [weak self] (responseModel) in
            guard let self = self else { return }
            LoadingView.hide()
            DispatchQueue.main.async {
                if responseModel?.status == StatusReponse.success {
                    self.customErrorMessage?.isHidden = true
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.customErrorMessage?.isHidden = false
                    self.errorLabel?.text = responseModel?.error
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registrationButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        clearErrorMessage()
        self.customErrorMessage?.isHidden = true
        let signupModel = SignUpModel.init(username: userNameTextfield?.textField.text, password: passwordTextField?.textField.text, confirmPassword: confirmPasswordTextfield?.textField.text)
        viewModel.validateInput(signupModel) { [weak self] (success, errorMessage) in
            guard let self = self else { return }
            if success {
                self.performAPICall()
            } else {
                switch errorMessage {
                case Constants.usernameEmptyMessage:
                    userNameTextfield?.errorString = errorMessage
                case Constants.passwordEmptyMessage:
                    passwordTextField?.errorString = errorMessage
                case Constants.passwordErrorMessage:
                    passwordTextField?.errorString = errorMessage
                case Constants.confirmPasswordEmptyMessage:
                    confirmPasswordTextfield?.errorString = errorMessage
                case Constants.passwordMismatchErrorMessage:
                    confirmPasswordTextfield?.errorString = errorMessage
                default:
                    break
                }
            }
        }
    }
}

// MARK: - TextField Delegate
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextfield?.textField {
            passwordTextField?.textField.becomeFirstResponder()
        } else if textField == passwordTextField?.textField {
            confirmPasswordTextfield?.textField.becomeFirstResponder()
        } else if textField == confirmPasswordTextfield?.textField {
            registrationButtonAction(registerButton ?? UIButton())
        }
        return true
    }
}
