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
class NavigationCoordinator<T: ViewController>: Coordinator, NavigationCoordinating {
    
    /// Контроллер, на котором происходит презентация.
    private(set) var presentationVC: UINavigationController
    
    /// Контроллер модуля.
    private(set) var presentingVC: T!
    
    /// Дочерний роутер.
    private(set) weak var child: NavigationCoordinating?
    
    /// Конструктор класса, с использованием резольвера и презентующего контроллера.
    init(_ resolver: Resolver, presentationVC: UINavigationController) {
        self.presentationVC = presentationVC
        super.init(resolver)
    }
    
    // MARK: - Public
    
    /// Имеет ли модуль собственную иерархию навигации.
    /// Если да, то будет создан отдельный контроллер навигации.
    /// В противном случае, модуль будет представлен на родительском контроллере.
    /// По-умолчанию, нет.
    var hasOwnHierarchy: Bool {
        return false
    }
    
    /// Показывать ли бар навигации.
    /// По-умолчанию, показывать.
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
    
    /// Показать дочерний координатор.
    func openChild(_ child: NavigationCoordinating) {
        child.start()
        self.child = child
    }
    
    // MARK: - NavigationCoordinating
    
    func start() {
        presentingVC = self.instantiateViewController()
        presentingVC.lifeCycleDelegate = self
        
        let navigationVC = !hasOwnHierarchy ? presentationVC : {
            let navigationVC = UINavigationController()
            navigationVC.modalPresentationStyle = .overCurrentContext
            return navigationVC
        }()
        navigationVC.pushViewController(presentingVC, animated: true)
        navigationVC.setNavigationBarHidden(isNavigationBarHidden, animated: true)
        
        if hasOwnHierarchy {
            presentationVC.present(
                navigationVC,
                animated: true,
                completion: nil
            )
            presentationVC = navigationVC
        }
    }

    func close() {
        presentationVC.popViewController(animated: true)
    }
}

extension NavigationCoordinator: ViewLifeCycleDelegate {
    
    func viewWillAppear() {
        presentationVC.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }
    
    func viewWillDisappear() {
        // Do nothing...
    }
}
