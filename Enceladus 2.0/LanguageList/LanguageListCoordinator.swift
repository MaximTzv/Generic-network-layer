//
//  LanguageListCoordinator.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit
import RxSwift

enum LanguageListCoordinatorResult {
    case language(String)
    case cancel
}

class LanguageListCoordinator: BaseCoordinator<LanguageListCoordinatorResult> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<LanguageListCoordinatorResult> {
        let viewController = LanguageListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        let viewModel = LanguageListViewModel()
        viewController.viewModel = viewModel

        let cancel = viewModel.didCancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.didSelectLanguage.map { CoordinationResult.language($0) }
        
        rootViewController.present(navigationController, animated: true, completion: nil)
        
        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in
                self?.rootViewController.dismiss(animated: true, completion: nil)
            })
    }
}
