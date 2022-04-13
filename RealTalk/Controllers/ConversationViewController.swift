//
//  ConversationViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit
import FirebaseAuth

class ConversationViewController: BaseViewController {
    
    private let selfView = ConversationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func validateAuth() {
        AuthManager.shared.checkCurrentUser { [weak self] isExistUser in
            if !isExistUser {
                print("no User exist")
                // No Exist user
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: false, completion: nil)
            }
            else {
                print("user exist")
                // Exist user
            }
        }
    }
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(selfView)
        selfView.translatesAutoresizingMaskIntoConstraints = false
        selfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selfView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        selfView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        selfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
