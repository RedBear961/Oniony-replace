//
//  StartUpPresenter.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import Foundation

protocol StartUpViewOutput {}

final class StartUpPresenter: StartUpViewOutput {
    
    private weak var viewInput: StartUpViewInput?
    private let coordinator: StartUpCoordinating
    
    init(
        viewInput: StartUpViewInput,
        coordinator: StartUpCoordinating
    ) {
        self.viewInput = viewInput
        self.coordinator = coordinator
    }
}
