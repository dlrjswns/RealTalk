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
    }
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
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
