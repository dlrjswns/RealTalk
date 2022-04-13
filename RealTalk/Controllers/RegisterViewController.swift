//
//  RegisterViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit
import FirebaseAuth

class RegisterViewController: BaseViewController {
    
    private let selfView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        title = "Create Account"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
//                                                            style: .done,
//                                                            target: self,
//                                                            action: #selector(didTapRegister))
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
        presentPhotoActionSheet()
    }
    
//    @objc private func didTapRegister() {
//        let vc = RegisterViewController()
//        vc.title = "Create Account"
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
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
        
        DatabaseManager.shared.userExists(with: email) { [weak self] isExist in
            guard !isExist else {
                // user already exists
                self?.alertUserLoginError(message: "Looks like a user account for that email address already exists")
                return
            }
        }
        
        AuthManager.shared.createUser(email: email, password: password) { [weak self] isRegister in
            if isRegister {
                // success register
                print("Success Register")
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                
                self?.navigationController?.popViewController(animated: true)
            }
            else {
                // fail register
                print("Fail Register")
            }
        }
    }
    
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
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

//MARK: -UITextFieldDelegate
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

//MARK: -UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true //편집가능여부 확인
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true //편집가능여부 확인
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.selfView.imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: -UINavigationControllerDelegate
extension RegisterViewController: UINavigationControllerDelegate {
    
}
