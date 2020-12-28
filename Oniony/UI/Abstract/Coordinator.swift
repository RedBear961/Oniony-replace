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
    
    var isNavigationBarHidden: Bool {
        return false
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
        presentationVC.isNavigationBarHidden = isNavigationBarHidden
    }

    func close() {
        presentationVC.popViewController(animated: true)
    }
}
