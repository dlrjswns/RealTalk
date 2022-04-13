//
//  LoginViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private let selfView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        selfView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        selfView.emailField.delegate = self
        selfView.passwordField.delegate = self
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLoginButton() {
        
        selfView.emailField.resignFirstResponder()
        selfView.passwordField.resignFirstResponder()
        
        guard let email = selfView.emailField.text,
              let password = selfView.passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                    alertUserLoginError()
                    return
        }
        
        AuthManager.shared.loginUser(email: email, password: password) { [weak self] isLogin in
            if !isLogin {
                // Fail Log In
                print("Failed Log In")
            }
            else {
                // Success Log In
                print("Success Log In")
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to log in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func configureUI() {
        title = "Log In"
        view.backgroundColor = .white
        view.addSubview(selfView)
        selfView.translatesAutoresizingMaskIntoConstraints = false
        selfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selfView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        selfView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        selfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == selfView.emailField {
            selfView.passwordField.becomeFirstResponder()
        }
        else if textField == selfView.passwordField {
            didTapLoginButton()
        }
        return true
    }
}
