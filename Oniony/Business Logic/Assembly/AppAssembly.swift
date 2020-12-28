//
//  AppAssembly.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import Swinject

/// Сборщик корневых объектов приложения.
final class AppAssembly: AutoAssembly {
    
    /// Стартовый координатор приложения.
    dynamic func appCoordinator() {
        container.register(AppCoordinating.self) { (resolver) -> AppCoordinator in
            return AppCoordinator(
                resolver: resolver,
                navigationVC: UINavigationController()
            )
        }
    }
}
