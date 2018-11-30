//
//  RepositoryCell.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit

class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL
    
    init(repo: Repository) {
        self.name = repo.fullName
        self.description = repo.description
        self.starsCountText = "🔸\(repo.starsCount)"
        self.url = URL(string: repo.url)!
    }
}

class RepositoryCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var starsCountLabel: UILabel!
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setDescription(_ desc: String) {
        descriptionLabel.text = desc
    }
    
    func setStarCount(_ starsCount: String) {
        starsCountLabel.text = starsCount
    }
}
