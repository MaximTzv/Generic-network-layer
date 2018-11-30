//
//  LanguageListViewModel.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import Foundation
import RxSwift

class LanguageListViewModel {
    
    // MARK: - Inputs
    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>
    
    // MARK: - Outputs
    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>
    
    init(service: GithubService = GithubService()) {
        
        self.languages = service.getLanguageList()
        
        let _selectLanguage = PublishSubject<String>()
        self.selectLanguage = _selectLanguage.asObserver()
        self.didSelectLanguage = _selectLanguage.asObservable()
        
        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
    }
}
