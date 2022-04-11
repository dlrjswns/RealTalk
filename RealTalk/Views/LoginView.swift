//
//  LoginView.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit

class LoginView: BaseView {
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    let emailField: UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email Address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordField: UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
        
        emailField.widthAnchor.constraint(equalToConstant: scrollView.width - 60).isActive = true
        passwordField.widthAnchor.constraint(equalToConstant: scrollView.width - 60).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: scrollView.width - 60).isActive = true
    }
    
    override func configureUI() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        emailField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        scrollView.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.centerXAnchor.constraint(equalTo: emailField.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        scrollView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
//        imageView.widthAnchor.constraint(equalToConstant: self.frame.width / 4).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: self.frame.width / 4).isActive = true
    }
}
