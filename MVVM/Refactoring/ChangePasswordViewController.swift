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
    var viewModel: ChangePasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleButton()
    }
    
    @IBAction private func cancel() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction private func changePassword() {
        guard validateInputs() else {
            return
        }
        setupWaitingAppearance()
        attemptToChangePassword()
    }
    
    private func validateInputs() -> Bool {
        if oldPasswordTextField.text?.isEmpty ?? true {
            oldPasswordTextField.becomeFirstResponder()
            return false
        }
        
        if newPasswordTextField.text?.isEmpty ?? true {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if newPasswordTextField.text?.count ?? 0 < 6 {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        
        if newPasswordTextField.text != confirmPasswordTextField.text {
            showAlert(message: viewModel.confirmationPasswordDoesNotMatchMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        return true
    }
    
    private func setupWaitingAppearance() {
        view.endEditing(true)
        
        cancelBarButton.isEnabled = false
        view.backgroundColor = .clear
        
        view.addSubview(blurView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    private func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: oldPasswordTextField.wrappedText,
            newPassword: newPasswordTextField.wrappedText,
            onSuccess: handleOnSuccess,
            onFailure: handleOnFailure
        )
    }
    
    private func showAlert(message: String,okAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: nil,message: message, preferredStyle: .alert)
        let okButton = UIAlertAction( title: viewModel.okButtonLabel,style: .default,handler: okAction)
        alert.addAction(okButton)
        alert.preferredAction = okButton
        self.present(alert, animated: true)
    }
    
    private func resetNewPassword() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        newPasswordTextField.becomeFirstResponder()
    }
    
    private func hideSpiner() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func handleOnSuccess() {
        hideSpiner()
        
        showAlert(message: viewModel.successMessage) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    private func handleOnFailure(message: String) {
        hideSpiner()
        
        showAlert(message: message) { [weak self] _ in
            self?.startOver()
        }
    }
    
    private func styleButton() {
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(red: 55/255.0, green: 147/255.0, blue: 251/255.0, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 8
    }
    
    private func startOver() {
        oldPasswordTextField.setEmpty()
        newPasswordTextField.setEmpty()
        confirmPasswordTextField.setEmpty()
        oldPasswordTextField.becomeFirstResponder()
        view.backgroundColor = .white
        blurView.removeFromSuperview()
        cancelBarButton.isEnabled = true
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField === newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
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
