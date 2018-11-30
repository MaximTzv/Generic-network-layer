//
//  BaseCoordinator.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/26/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import UIKit
import RxSwift

protocol StoryboardInitializable {
    static var storyboardId: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardId: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! Self
    }
}

// Generic coordinator
class BaseCoordinator<ResultType> {
    
    typealias CoordinationResult = ResultType
    
    // used by the subclasses
    let bag = DisposeBag()
    
    // unique identifier
    private let identifier = UUID()
    
    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        
        store(coordinator: coordinator)
        
        return coordinator.start().do(onNext: { [weak self] _ in
            self?.free(coordinator: coordinator)
        })
    }
    
    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented")
    }
}
