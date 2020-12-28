//
//  AppCoordinator.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import Swinject

/// Протокол основного координатора приложения.
protocol AppCoordinating {
    
    /// Запускает навигацию.
    /// - Parameter window: Корневое окно приложения.
    func start(with window: UIWindow)
}

/// Основной координатор приложения.
final class AppCoordinator: Coordinator, AppCoordinating {
    
    private let rootNavigationVC: UINavigationController
    private var child: NavigationCoordinating?
    
    init(resolver: Resolver, navigationVC: UINavigationController) {
        self.rootNavigationVC = navigationVC
        super.init(resolver)
    }
    
    // MARK: - AppCoordinating
    
    func start(with window: UIWindow) {
        let child = resolver.resolve(StartUpCoordinating.self, argument: rootNavigationVC)!
        child.start()
        self.child = child
        window.rootViewController = rootNavigationVC
        window.makeKeyAndVisible()
    }
}
