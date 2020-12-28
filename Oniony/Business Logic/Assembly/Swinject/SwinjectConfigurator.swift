/*
 * Copyright (c) 2020 WebView, Lab
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
