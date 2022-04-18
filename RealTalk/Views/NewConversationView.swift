//
//  NewConversationView.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/11.
//

import UIKit

class NewConversationView: BaseView {
    
    let tableView: UITableView = {
        $0.register(UITableViewCell.self,
                    forCellReuseIdentifier: "cell")
       return $0
    }(UITableView())
    
    let noResultsLabel: UILabel = {
        $0.text = "No Results"
        $0.textAlignment = .center
        $0.textColor = .green
        $0.font = .systemFont(ofSize: 21, weight: .medium)
       return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        
    }
}
