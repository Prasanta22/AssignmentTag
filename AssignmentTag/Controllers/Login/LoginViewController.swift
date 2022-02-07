//
//  LoginViewController.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 06/02/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var customErrorMessage: UIView!
    @IBOutlet weak var userNameTextfield: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Button Setup
    func buttonSetup() {
        loginButton.configure(30, borderColor: .black)
        registerButton.configure(30, borderColor: .black)
    }
    
    /// Funciton to setup UI
    func setupUI() {
        customErrorMessage.isHidden = true
        setUpTextfields()
        loadCustomErrorView()
        buttonSetup()
    }
    
    /// Funciton to setup textinputs
    func setUpTextfields() {
        userNameTextfield?.placeHolderLabel.text = Constants.username
        passwordTextField?.placeHolderLabel.text = Constants.password
        userNameTextfield?.textField.delegate = self
        passwordTextField?.textField.delegate = self
        userNameTextfield?.textField.returnKeyType = .next
        passwordTextField?.textField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /// Load ErrorView
    func loadCustomErrorView() {
        customErrorMessage.addViewBorder(borderColor: UIColor.red.cgColor,
                                         borderWith: 1.2,
                                         borderCornerRadius: 12.0)
    }
    
    /// Clear error message
    func clearErrorMessage() {
        userNameTextfield.errorString = nil
        passwordTextField.errorString = nil
    }
    
    // MARK: - IBAction
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        clearErrorMessage()
        // LoadingView.show()
        viewModel.validateInput(userNameTextfield.textField.text, password: passwordTextField.textField.text) { [weak self] (success, message) in
            if success {
                guard let self = self else { return }
                //self.performAPICall()
                LoadingView.hide()
            } else {
                switch message {
                case Constants.usernameEmptyMessage:
                    userNameTextfield.errorString = message
                case Constants.passwordEmptyMessage:
                    passwordTextField.errorString = message
                case Constants.passwordErrorMessage:
                    passwordTextField.errorString = message
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
               if let navigator = navigationController {
                   navigator.pushViewController(viewController, animated: true)
               }
           }
    }
    
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextfield.textField {
            passwordTextField.textField.becomeFirstResponder()
        } else if textField == passwordTextField.textField {
            loginButtonAction(loginButton)
        }
        return true
    }
}
