//
//  RepositoryListCoordinator.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class RepositoryListCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = RepositoryOverviewViewModel(initialLanguage: "Swift")
        let viewController = RepositoryOverviewViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.showRepository.subscribe(onNext: { [weak self] in
            self?.showRepository(by: $0, in: navigationController)
        }).disposed(by: bag)
        
        viewModel.showLanguageList.flatMap { [weak self] _ -> Observable<String?> in
            guard let strongSelf = self else { return Observable.empty() }
            return strongSelf.showLanguageList(on: viewController)
        }
        .filter { $0 != nil }
        .map { $0! }
        .bind(to: viewModel.setCurrentLanguage)
        .disposed(by: bag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showRepository(by url: URL, in navigationController: UINavigationController) {
        let safariController = SFSafariViewController(url: url)
        navigationController.pushViewController(safariController, animated: true)
    }
    
    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
        let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
        
        return coordinate(to: languageListCoordinator).map { result in
            switch result {
            case .language(let lang): return lang
            case .cancel: return nil
            }
        }
    }
}
