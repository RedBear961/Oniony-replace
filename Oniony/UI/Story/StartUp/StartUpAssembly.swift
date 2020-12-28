//
//  StartUpAssembly.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import Swinject

final class StartUpAssembly: AutoAssembly {
    
    dynamic func startUpViewController() {
        container.register(
            StartUpViewController.self
        ) { (resolver, coordinator: StartUpCoordinating) -> StartUpViewController in
            let controller = StoryboardScene.StartUp.startUpViewController.instantiate()
            controller.viewOutput = resolver.resolve(
                StartUpViewOutput.self,
                arguments: controller as StartUpViewInput, coordinator
            )!
            return controller
        }
    }
    
    dynamic func startUpPresenter() {
        container.register(
            StartUpViewOutput.self
        ) { (_, viewInput: StartUpViewInput, coordinator: StartUpCoordinating) -> StartUpPresenter in
            return StartUpPresenter(viewInput: viewInput, coordinator: coordinator)
        }
    }
    
    dynamic func startUpCoordinator() {
        container.register(
            StartUpCoordinating.self
        ) { (resolver, navigationVC: UINavigationController) -> StartUpCoordinator in
            return StartUpCoordinator(resolver, presentationVC: navigationVC)
        }
    }
}
