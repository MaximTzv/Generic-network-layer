//
//  MainViewController.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/29/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var githutManager: GithubManager!
    
    init(manager: GithubManager) {
        super.init(nibName: nil, bundle: nil)
        self.githutManager = manager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        githutManager.getMostPopularLanguage(byLanguage: "swift") { (repo, error) in
            if let error = error {
                print(error)
            }
            
            if let repo = repo {
                print(repo)
            }
        }
    }
}
