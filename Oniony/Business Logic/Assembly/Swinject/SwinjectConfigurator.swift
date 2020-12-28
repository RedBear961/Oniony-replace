//
//  SwinjectConfigurator.swift
//  Hypee
//
//  Created by Георгий Черемных on 27.05.2020.
//  Copyright © 2020 Anatomy Karma. All rights reserved.
//

import Swinject
import UIKit

protocol SwinjectConfigurating {
    
    /// Основной DI-контейнер.
    var resolver: Resolver { get }
}

final class SwinjectConfigurator: SwinjectConfigurating {
    
    /// Singleton-экземпляр конфигуратора.
    static var shared: SwinjectConfigurator = {
        let c = SwinjectConfigurator()
        c.configure()
        return c
    }()
    
    var resolver: Resolver {
        return container
    }
    
    /// Основной DI-контейнер.
    private let container = Container()
    
    // Провайдер сборщиков.
    private let assembler: Assembler
    
    // Сделан приватным, чтобы пользовались только `shared`.
    private init() {
        assembler = Assembler(container: container)
    }
    
    // Находит все сборщики в проекте и активирует их.
    private func configure() {
        let assemblies = assemblyList()
        assembler.apply(assemblies: assemblies)
    }
    
    // Находит все сборщики в проекте и возвращает их в виде массива.
    private func assemblyList() -> [Assembly] {
        var count: UInt32 = 0
        guard let executablePath = Bundle.main.executablePath,
              let classNames = objc_copyClassNamesForImage(executablePath.cString, &count) else {
            preconditionFailure("Не удалось получить список классов для бандла \(Bundle.main)!")
        }
        
        var list = [Assembly]()
        
        for i in 0..<Int(count) {
            let pointer = classNames[i]
            guard let className = String(from: pointer, encoding: .utf8) else { continue }
            
            let aClass: AnyClass? = NSClassFromString(className)
            if let assembly = aClass as? (NSObject & Assembly).Type,
               assembly != AutoAssembly.self {
                list.append(assembly.init())
            }
        }
        
        return list
    }
}
