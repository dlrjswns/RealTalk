//
//  ProfileViewController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit
import FirebaseAuth

class ProfileViewController: BaseViewController {
    
    private let selfView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profiles"
        
        selfView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
        
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: { _ in
                                            AuthManager.shared.logOutUser { [weak self] logout in
                                                if logout {
                                                    // Success logout
                                                    let vc = LoginViewController()
                                                    let nav = UINavigationController(rootViewController: vc)
                                                    nav.modalPresentationStyle = .fullScreen
                                                    self?.present(nav, animated: true, completion: nil)
                                                }
                                                else {
                                                    // Failed logout
                                                }
                                            }
                                      }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "dfdfdd"
        return cell
    }
}
