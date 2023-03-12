//
//  ChangePasswordViewController.swift
//  Refactoring
//
//  Created by Mohamed Ibrahim on 05/03/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!
    
    //MARK: - Views
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        return view
    }()
    
    var securityToken = ""
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    
    var labels: ChangePasswordLabels!
    
    private lazy var presenter = ChangePasswordPresenter(view: self, labels: labels,securityToken: securityToken,passwordChanger: passwordChanger)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleButton()
        setLabels()
    }
    
    @IBAction private func cancel() {
        presenter.cancel()
    }
    
    @IBAction private func changePassword() {
        let passwordInputs = PasswordInputs(
            oldPassword: oldPasswordTextField.wrappedText,
            newPassword: newPasswordTextField.wrappedText,
            confirmPassword: confirmPasswordTextField.wrappedText
        )
        presenter.changePassword(passwordInputs: passwordInputs)
        
    }
    
    private func showAlert(message: String,okAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: nil,message: message, preferredStyle: .alert)
        let okButton = UIAlertAction( title: labels.okButtonLabel,style: .default,handler: okAction)
        alert.addAction(okButton)
        alert.preferredAction = okButton
        self.present(alert, animated: true)
    }
}

//MARK: - ChangePasswordViewCommands

extension ChangePasswordViewController: ChangePasswordViewCommands {
    
    func resetNewPassword() {
        clearNewPasswordFields()
        updateInputFocus(.newPassword)
    }
    
    func clearNewPasswordFields() {
        newPasswordTextField.setEmpty()
        confirmPasswordTextField.setEmpty()
    }
    
    func clearAllPasswordFields() {
        oldPasswordTextField.setEmpty()
        newPasswordTextField.setEmpty()
        confirmPasswordTextField.setEmpty()
    }
    
    func updateInputFocus(_ inputFoucs: InputFocus) {
        switch inputFoucs {
        case .noKeyboard:
            view.endEditing(true)
            
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
            
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
            
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
    
    func setCancelButtonEnabled(_ enabled: Bool) {
        cancelBarButton.isEnabled = enabled
    }
    
    func showBlurView() {
        view.backgroundColor = .clear
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func hideBlurView() {
        view.backgroundColor = .white
        blurView.removeFromSuperview()
    }
    
    func showAlert(message: String,action: @escaping () -> Void) {
        let wrappedAction: (UIAlertAction) -> Void = { _ in action() }
        showAlert(message: message, okAction: wrappedAction)
    }
    
    func dismissModal() {
        dismiss(animated: true)
    }
    
    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

//MARK: - Update UI

extension ChangePasswordViewController {
    
    private func styleButton() {
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(red: 55/255.0, green: 147/255.0, blue: 251/255.0, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 8
    }
    
    private func setLabels() {
        navigationBar.topItem?.title = labels.title
        oldPasswordTextField.placeholder = labels.oldPasswordPlaceholder
        newPasswordTextField.placeholder = labels.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = labels.confirmPasswordPlaceholder
        submitButton.setTitle(labels.submitButtonLabel, for: .normal)
    }
}

//MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            updateInputFocus(.newPassword)
        } else if textField === newPasswordTextField {
            updateInputFocus(.confirmPassword)
        } else if textField == confirmPasswordTextField {
            changePassword()
        }
        
        return true
    }
}

private extension UITextField {
    var wrappedText: String {
        self.text ?? ""
    }
    
    func setEmpty() {
        self.text = ""
    }
}
