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
    
    var viewModel: ChangePasswordViewModel! {
        didSet {
            guard isViewLoaded else { return }
            
            if oldValue.isCancelButtonEnabled != viewModel.isCancelButtonEnabled {
                cancelBarButton.isEnabled = viewModel.isCancelButtonEnabled
            }
            
            if oldValue.inputFocus != viewModel.inputFocus {
                updateInputFocus()
            }
            
            if oldValue.isBlurViewShowing != viewModel.isBlurViewShowing {
                updateBlurView()
            }
            
            if oldValue.isActivityIndicatorShowing != viewModel.isActivityIndicatorShowing {
                updateActivityIndicator()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleButton()
        setLabels()
    }
    
    @IBAction private func cancel() {
        viewModel.inputFocus = .noKeyboard
        dismiss(animated: true)
    }
    
    @IBAction private func changePassword() {
        updateViewModelToTextFields()
        guard validateInputs() else {
            return
        }
        setupWaitingAppearance()
        attemptToChangePassword()
    }
    
    private func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            oldPasswordTextField.becomeFirstResponder()
            return false
        }
        
        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if viewModel.isNewPasswordTooShort {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        
        if viewModel.isConfirmationPasswordMismatch {
            showAlert(message: viewModel.confirmationPasswordDoesNotMatchMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        return true
    }
    
    private func setupWaitingAppearance() {
        viewModel.inputFocus = .noKeyboard
        viewModel.isCancelButtonEnabled = false
        viewModel.isBlurViewShowing = true
        viewModel.isActivityIndicatorShowing = true
    }
    
    private func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: viewModel.oldPassword,
            newPassword: viewModel.newPassword,
            onSuccess: handleOnSuccess,
            onFailure: handleOnFailure
        )
    }
    
    private func updateInputFocus() {
        switch viewModel.inputFocus {
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
    
    private func showAlert(message: String,okAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: nil,message: message, preferredStyle: .alert)
        let okButton = UIAlertAction( title: viewModel.okButtonLabel,style: .default,handler: okAction)
        alert.addAction(okButton)
        alert.preferredAction = okButton
        self.present(alert, animated: true)
    }
    
    private func resetNewPassword() {
        newPasswordTextField.setEmpty()
        confirmPasswordTextField.setEmpty()
        newPasswordTextField.becomeFirstResponder()
    }
    
    private func updateViewModelToTextFields() {
        viewModel.oldPassword = oldPasswordTextField.wrappedText
        viewModel.newPassword = newPasswordTextField.wrappedText
        viewModel.confirmPassword = confirmPasswordTextField.wrappedText
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
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceholder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonLabel, for: .normal)
    }
    
    private func updateBlurView() {
        if viewModel.isBlurViewShowing {
            view.backgroundColor = .clear
            view.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
        } else {
            view.backgroundColor = .white
            blurView.removeFromSuperview()
        }
    }
    
    private func updateActivityIndicator() {
        if viewModel.isActivityIndicatorShowing {
            view.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            activityIndicator.startAnimating()
        } else {
            hideSpiner()
        }
    }
    
    private func hideSpiner() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

//MARK: - Api response

extension ChangePasswordViewController {
    private func handleOnSuccess() {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: viewModel.successMessage) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    private func handleOnFailure(message: String) {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: message) { [weak self] _ in
            self?.startOver()
        }
    }
    
    private func startOver() {
        oldPasswordTextField.setEmpty()
        newPasswordTextField.setEmpty()
        confirmPasswordTextField.setEmpty()
        oldPasswordTextField.becomeFirstResponder()
        viewModel.isBlurViewShowing = false
        viewModel.isCancelButtonEnabled = true
    }
}


extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            viewModel.inputFocus = .newPassword
        } else if textField === newPasswordTextField {
            viewModel.inputFocus = .confirmPassword
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
