//
//  TransferViewController.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var customErrorMessage: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionBackView: UIView!
    @IBOutlet weak var amountTextField: CustomTextField!
    @IBOutlet weak var payeeTextField: CustomTextField!
    var payeePicker: UIPickerView! = UIPickerView()
    var viewModel = TransferViewModel()
    private var payeesList: [PayeeData]?
    private var index: Int = 0
    private var accountNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getPayeeList()
    }
    
    /// Hide Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Button Setup
    func buttonSetup() {
        transferButton.configure(30, borderColor: .black)
    }
    
    /// Funciton to setup UI
    func setupUI() {
        customErrorMessage.isHidden = true
        setUpTextfields()
        buttonSetup()
        descriptionBackView?.addViewBorder(borderColor: UIColor.black.cgColor,
                                              borderWith: 1.5,
                                              borderCornerRadius: 1.0)
        setUpPickerView()
    }
    
    /// Funciton to setup textfields
    private func setUpTextfields() {
        payeeTextField?.placeHolderLabel.text = Constants.payeeText
        amountTextField?.placeHolderLabel.text = Constants.amountText
        amountTextField?.textField.keyboardType = .numberPad
        payeeTextField?.textField.delegate = self
        amountTextField?.textField.delegate = self
        descriptionTextView?.delegate = self
        payeeTextField?.textField.inputView = payeePicker
        payeeTextField?.textField.tintColor = .clear
        payeeTextField?.textField.setRightImage(imageName: Constants.downButtonImage)
        addDoneButtonOnKeyboard()
    }
    
    /// Funciton to setup picker view
    private func setUpPickerView() {
        payeePicker.delegate = self
        payeePicker.dataSource = self
        payeePicker.reloadAllComponents()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: Constants.done,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: Constants.cancel,
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton],
                         animated: false)
        toolBar.isUserInteractionEnabled = true
        
        payeeTextField?.textField.inputView = payeePicker
        payeeTextField?.textField.inputAccessoryView = toolBar
    }
    
    /// Funciton to close picker after selection
    @objc func doneTapped() {
        guard let payees = payeesList else { return }
        payeeTextField.textField.text = payees[index].name
        accountNo = payees[index].accountNo
        payeeTextField.errorString = nil
        payeeTextField.textField.resignFirstResponder()
    }
    
    /// Funciton to close picker
    @objc func cancelTapped() {
        payeeTextField.textField.resignFirstResponder()
    }
    /// Function to add done button on keyboard
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor.black
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: Constants.done,
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        amountTextField?.textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        amountTextField.textField.resignFirstResponder()
    }
    
    func getPayeeList() {
        LoadingView.show()
        viewModel.payeeList { [weak self] (responseModel) in
            guard let self = self else { return }
            LoadingView.hide()
            DispatchQueue.main.async {
                if responseModel?.status == StatusReponse.success {
                    self.payeesList = responseModel?.data
                    self.payeePicker.reloadAllComponents()
                    self.customErrorMessage.isHidden = true
                } else {
                    self.customErrorMessage.isHidden = false
                    self.errorLabel.text = responseModel?.error
                }
            }
        }
    }
    
    /// Clear error message
    func clearErrorMessage() {
        payeeTextField.errorString = nil
        amountTextField.errorString = nil
    }
    
    private func performAPICall() {
        LoadingView.show()
        guard let amount = amountTextField.textField.text, let amountCount = Int64(amount) else {
            /// Not valid
            return
        }
        let request = TransferRequestModel(payeeName: accountNo, amount: Int(amountCount), description: descriptionTextView.text!)
        viewModel.makeTransfer(request) { [weak self] (responseModel) in
            guard let self = self else { return }
            LoadingView.hide()
            DispatchQueue.main.async {
                if responseModel?.status == StatusReponse.success {
                    self.customErrorMessage.isHidden = true
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.customErrorMessage.isHidden = false
                    self.errorLabel.text = responseModel?.error
                }
            }
        }
    }
    
    @IBAction func transferButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        clearErrorMessage()
        viewModel.validateInput(payeeTextField.textField.text, amount: amountTextField.textField.text) { [weak self] (success, message) in
            if success {
                guard let self = self else { return }
                self.performAPICall()
            } else {
                switch message {
                case Constants.payeeEmptyMessage:
                    payeeTextField.errorString = message
                case Constants.amountEmptyMessage:
                    amountTextField.errorString = message
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension TransferViewController: UITextFieldDelegate, UITextViewDelegate {
    /// Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == payeeTextField.textField {
            amountTextField.textField.becomeFirstResponder()
        } else if textField == amountTextField.textField {
            descriptionTextView.becomeFirstResponder()
        } else {
            descriptionTextView.becomeFirstResponder()
        }
        return true
    }
    
    /// Textview delegate
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /// Pickerview delegate and datasources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let payees = payeesList else { return 0 }
        return payees.count
    }
    
    func pickerView( _ pickerView: UIPickerView,
                     titleForRow row: Int,
                     forComponent component: Int) -> String? {
        guard let payees = payeesList else { return "" }
        let conditionIndex = payees[row].accountNo.count - 5
        let maskedName = String(payees[row].accountNo.enumerated().map { (index, element) -> Character in
            return index < conditionIndex ? "X" : element
        })
        return payees[row].name + " " +  maskedName
    }
    
    func pickerView( _ pickerView: UIPickerView,
                     didSelectRow row: Int,
                     inComponent component: Int) {
        index = row
    }
}
