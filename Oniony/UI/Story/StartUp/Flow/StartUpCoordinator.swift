//
//  StartUpCoordinator.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import UIKit

/// Протокол координатора модуля запуска тор-сети,
protocol StartUpCoordinating: NavigationCoordinating {}

/// Координатор модуля запуска тор-сети,
final class StartUpCoordinator: NavigationCoordinator<StartUpViewController>, StartUpCoordinating {
    
    // MARK: - Override
    
    override func instantiateViewController() -> StartUpViewController {
        return resolver.resolve(StartUpViewController.self, argument: self as StartUpCoordinating)!
    }
}
