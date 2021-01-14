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

import UIKit

/// Протокол координатора модуля запуска тор-сети,
protocol StartUpCoordinating: NavigationCoordinating {
    
    /// Открыть модуль настройки сети.
    func openNetwork()
    
    /// Открыть модуль вкладок.
    func openTab()
}

/// Координатор модуля запуска тор-сети,
final class StartUpCoordinator: NavigationCoordinator<StartUpViewController>, StartUpCoordinating {
    
    // MARK: - Override
    
    override var isNavigationBarHidden: Bool {
        return true
    }
    
    override func instantiateViewController() -> StartUpViewController {
        return resolver.resolve(StartUpViewController.self, argument: self as StartUpCoordinating)!
    }
    
    // MARK: - StartUpCoordinating
    
    // Открыть модуль настройки сети.
    func openNetwork() {
        let child = resolver.resolve(
            NetworkCoordinating.self,
            argument: presentationVC
        )!
        openChild(child)
    }
    
    func openTab() {
        let child = resolver.resolve(
            TabCoordinating.self,
            argument: presentationVC
        )!
        openChild(child)
    }
}
