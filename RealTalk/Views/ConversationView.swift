//
//  ConversationView.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit

class ConversationView: BaseView {
    
    let tableView: UITableView = {
        $0.isHidden = true
        $0.register(UITableViewCell.self,
                    forCellReuseIdentifier: "cell")
       return $0
    }(UITableView())
    
    let noConversationsLabel: UILabel = {
        $0.text = "No Conversations!"
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.isHidden = true
      return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(noConversationsLabel)
    }
}
