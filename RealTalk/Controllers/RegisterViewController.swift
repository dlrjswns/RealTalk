//
//  RegisterViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    private let selfView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        selfView.registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        selfView.emailField.delegate = self
        selfView.passwordField.delegate = self
        
        selfView.imageView.isUserInteractionEnabled = true
        selfView.scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                          action: #selector(didTapChangeProfilePick))
//        gesture.numberOftou
        selfView.imageView.addGestureRecognizer(gesture)
    }
    
    //MARK: -Action
    @objc private func didTapChangeProfilePick() {
        print("Change pic called")
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        
        selfView.emailField.resignFirstResponder()
        selfView.passwordField.resignFirstResponder()
        selfView.firstNameField.resignFirstResponder()
        selfView.lastNameField.resignFirstResponder()
        
        guard let firstName = selfView.firstNameField.text,
              let lastName = selfView.lastNameField.text,
              let email = selfView.emailField.text,
              let password = selfView.passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count >= 6 else {
                    alertUserLoginError()
                    return
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to create a new account.",
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == selfView.emailField {
            selfView.passwordField.becomeFirstResponder()
        }
        else if textField == selfView.passwordField {
            didTapRegisterButton()
        }
        return true
    }
}
