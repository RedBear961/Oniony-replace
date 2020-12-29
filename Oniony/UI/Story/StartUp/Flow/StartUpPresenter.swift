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

import Foundation

protocol StartUpViewOutput {
    
    /// Модуль был загружен.
    func moduleDidLoad()
    
    /// Нажата кнопка настроек запуска тор-сети.
    func settingDidTouch()
    
    /// Нажата кнопка соединиться с тор-сетью.
    func connectDidTouch()
}

final class StartUpPresenter: StartUpViewOutput {
    
    private weak var viewInput: StartUpViewInput?
    private let coordinator: StartUpCoordinating
    private let torDirector: TorNetworkDirecting
    
    private var cellObjects: [TorLoadingLogViewCellObject] = []
    
    init(
        viewInput: StartUpViewInput,
        coordinator: StartUpCoordinating,
        torDirector: TorNetworkDirecting
    ) {
        self.viewInput = viewInput
        self.coordinator = coordinator
        self.torDirector = torDirector
        self.torDirector.delegate = self
    }
    
    // MARK: - StartUpViewOutput
    
    // Модуль был загружен.
    func moduleDidLoad() {
        cellObjects.append(TorLoadingLogViewCellObject(title: L10n.TorLoading.log))
        viewInput?.update(with: cellObjects)
    }
    
    // Нажата кнопка настроек запуска тор-сети.
    func settingDidTouch() {
        coordinator.openNetwork()
    }
    
    // Нажата кнопка соединиться с тор-сетью.
    func connectDidTouch() {
        viewInput?.showProgress()
        torDirector.startTor()
    }
}

extension StartUpPresenter: TorNetworkDirectorDelegate {
    
    func torDirector(
        _ director: TorNetworkDirecting,
        didUpdate status: TorLoadingStatus
    ) {
        let cellObject = TorLoadingLogViewCellObject(title: status.log)
        cellObjects.append(cellObject)
        DispatchQueue.main.async {
            self.viewInput?.update(with: status)
            self.viewInput?.update(with: self.cellObjects)
        }
    }
    
    func torDirectorDidLoad(_ director: TorNetworkDirecting) {
    }
    
    func torDirector(_ director: TorNetworkDirecting, didFinishWith error: Error) {
    }
}
