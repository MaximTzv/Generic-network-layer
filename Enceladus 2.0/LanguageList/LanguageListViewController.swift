//
//  LanguageListViewController.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageListViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    let bag = DisposeBag()
    var viewModel: LanguageListViewModel!
    
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"
        
        tableView.rowHeight = 48.0
    }
    
    private func setupBindings() {
        
        viewModel.languages.observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { _, language, cell in
            cell.textLabel?.text = language
            cell.selectionStyle = .none
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(String.self).bind(to: viewModel.selectLanguage).disposed(by: bag)
        
        cancelButton.rx.tap.bind(to: viewModel.cancel).disposed(by: bag)
    }
}
