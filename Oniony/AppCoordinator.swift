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

/// Протокол основного координатора приложения.
protocol AppCoordinating {
    
    /// Запускает навигацию.
    /// - Parameter window: Корневое окно приложения.
    func start(with window: UIWindow)
}

/// Основной координатор приложения.
final class AppCoordinator: Coordinator, AppCoordinating {
    
    private let rootNavigationVC: UINavigationController
    private weak var child: NavigationCoordinating?
    
    init(resolver: Resolver, navigationVC: UINavigationController) {
        self.rootNavigationVC = navigationVC
        super.init(resolver)
    }
    
    // MARK: - AppCoordinating
    
    // Запускает навигацию.
    func start(with window: UIWindow) {
        let child = resolver.resolve(StartUpCoordinating.self, argument: rootNavigationVC)!
        child.start()
        self.child = child
        window.rootViewController = rootNavigationVC
        window.makeKeyAndVisible()
        
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = Asset.background.color
        appearance.tintColor = .white
        appearance.isTranslucent = false
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.barStyle = .black
        
        UITextField.appearance().tintColor = Asset.headerText.color
    }
}
