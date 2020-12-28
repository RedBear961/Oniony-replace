//
//  Coordinator.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import Swinject

/// Абстрактный класс роутера, содержащий резольвер.
class Coordinator {
    
    /// Резольвер контейнера Swinject.
    let resolver: Resolver
    
    init(_ resolver: Resolver) {
        self.resolver = resolver
    }
}

/// Протокол основного роутера навигации.
protocol NavigationCoordinating: class {
    
    /// Презентует модуль на основном контроллере.
    func start()
    
    /// Закрывает модуль.
    func close()
}

/// Абстрактный класс роутера навигации.
class NavigationCoordinator<T: UIViewController>: Coordinator, NavigationCoordinating {
    
    /// Контроллер, на котором происходит презентация.
    let presentationVC: UINavigationController
    
    /// Контроллер модуля.
    private(set) var presentingVC: T!
    
    /// Дочерний роутер.
    private(set) var child: NavigationCoordinating?
    
    /// Конструктор класса, с использованием резольвера и презентующего контроллера.
    init(_ resolver: Resolver, presentationVC: UINavigationController) {
        self.presentationVC = presentationVC
        super.init(resolver)
    }
    
    /// Создает модуль.
    ///
    /// Эта функция будет вызвана, который координатор должен представить модуль.
    /// Наследник должен переопределить эту функцию и создать мордуль.
    func instantiateViewController() -> T {
        preconditionFailure("Необходимо переопределить эту функции в наследнике!")
    }
    
    // MARK: - NavigationCoordinating
    
    func start() {
        presentingVC = self.instantiateViewController()
        presentationVC.pushViewController(presentingVC, animated: true)
    }

    func close() {
        presentationVC.popViewController(animated: true)
    }
}
