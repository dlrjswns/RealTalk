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
import JGProgressHUD

class LoginViewController: BaseViewController {
    
    private let selfView = LoginView()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main)
        { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        selfView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        selfView.emailField.delegate = self
        selfView.passwordField.delegate = self
        selfView.fbLoginButton.delegate = self
        
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
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
        
        spinner.show(in: view)
        
        AuthManager.shared.loginUser(email: email, password: password) { [weak self] isLogin in
            
            DispatchQueue.main.async {
                self?.spinner.dismiss()
            }
            
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
        print("token = \(token)")
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start { connection, result, error in
            guard let result = result as? [String: Any], error == nil else { // result = ["id": "", "name": 도정희, "email": leekyunjun@gmail.com]
                print("Failed to make facebook graph request")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any?],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                      return
            }
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    print("dsfadsfsfa")
                    let chatUser = ChatAppUser(firstName: firstName, lastName: "lastName", emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")
                                    }
                                }
                            }
                        }
                    })
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
