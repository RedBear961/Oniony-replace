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

protocol TabViewOutput: SearchBarDelegate {
    
    /// Модуль будет прорисован.
    func moduleWillAppear()
}

final class TabPresenter: TabViewOutput {
    
    private weak var viewInput: TabViewInput?
    private let coordinator: TabCoordinating
    private let tabManager: TabDirecting
    
    init(
        viewInput: TabViewInput,
        coordinator: TabCoordinating,
        tabManager: TabDirecting
    ) {
        self.viewInput = viewInput
        self.coordinator = coordinator
        self.tabManager = tabManager
    }
    
    // MARK: - TabViewOutput
    
    func moduleWillAppear() {
        let tab = tabManager.currentTab
        viewInput?.update(with: tab, tabCount: tabManager.tabs.count)
    }
    
    // MARK: - SearchBarDelegate
    
    func searchContainer(for searchBar: SearchBar) -> UIView {
        guard let viewInput = viewInput else {
            preconditionFailure("Должен быть представлен ответчик отображения!")
        }
        return viewInput.searchContainer()
    }
    
    func searchBarShouldShowSuggestions(_ searchBar: SearchBar) -> Bool {
        return false
    }
    
    func searchBar(_ searchBar: SearchBar, didUpdate text: String) {}
    
    func searchBar(_ searchBar: SearchBar, didFinishWith text: String) {
        
    }
}
