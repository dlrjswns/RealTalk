//
//  LoginViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit
import FacebookLogin
import Firebase
import FBSDKLoginKit

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
        selfView.fbLoginButton.delegate = self
        
        //FBLogin Token
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
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

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log In with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start { connection, result, error in
            guard let result = result as? [String: Any], error == nil else { // result = ["id": "", "name": 도정희, "email": leekyunjun@gmail.com]
                print("Failed to make facebook graph request")
                return
            }
            
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
//            guard nameComponents.count == 2 else {
//                print("dfdsfs?????")
//                return
//            }
            
            let firstName = nameComponents[0]
            
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    print("dsfadsfsfa")
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: "lastName",
                                                                        emailAddress: email))
                }
                print("tlq")
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            AuthManager.shared.signInWithFacebook(authCredential: credential) { [weak self] successSigninFacebook in
                if successSigninFacebook {
                    // Success log in facebook
                    print("succeesfsefe")
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
                else {
                    // Faild log in facebook
                    print("여기 ?")
                }
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    
}
