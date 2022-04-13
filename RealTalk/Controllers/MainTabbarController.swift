//
//  MainTabbarController.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/13.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbarController()
    }
    
    private func configureTabbarController() {
        
        let conversationVC = UINavigationController(rootViewController: ConversationViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        conversationVC.title = "Chats"
        profileVC.title = "Profiles"
        
        
        /// Set largeTitle
        conversationVC.navigationItem.largeTitleDisplayMode = .always
        conversationVC.navigationBar.prefersLargeTitles = true
        profileVC.navigationItem.largeTitleDisplayMode = .always
        profileVC.navigationBar.prefersLargeTitles = true
        
        self.setViewControllers([ conversationVC, profileVC ], animated: true)
        guard let items = self.tabBar.items else {
            return
        }
        
        for x in 0 ..< items.count {
            items[x].image = UIImage(systemName: "person.fill")
        }
        
    }
}
