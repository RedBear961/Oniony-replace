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

protocol BridgeViewOutput {
    
    /// Модуль был загружен.
    func moduleDidLoad()
    
    /// Активность мостов был изменена.
    func enableBridge(_ isEnabled: Bool)
    
    /// Выбрана ячейка с моделью.
    func didSelect(cellObject: CellObject)
    
    /// Выбран пользовательский мост.
    func customBridgeDidSelect(_ data: BridgeData)
}

final class BridgePresenter: BridgeViewOutput {
    
    private weak var viewInput: BridgeViewInput?
    private let coordinator: BridgeCoordinating
    private let factory: BridgeCellFactory
    private let bridgeDirector: BridgeDirecting
    
    init(
        viewInput: BridgeViewInput,
        coordinator: BridgeCoordinating,
        factory: BridgeCellFactory,
        bridgeDirector: BridgeDirecting
    ) {
        self.viewInput = viewInput
        self.coordinator = coordinator
        self.factory = factory
        self.bridgeDirector = bridgeDirector
    }
    
    // MARK: - BridgeViewOutput
    
    func moduleDidLoad() {
        let sectionObjects = factory.sectionObjects()
        viewInput?.update(with: sectionObjects)
    }
    
    func enableBridge(_ isEnabled: Bool) {
        bridgeDirector.isEnabled = isEnabled
        let sectionObjects = factory.sectionObjects()
        viewInput?.reload(with: sectionObjects)
    }
    
    func didSelect(cellObject: CellObject) {
        switch cellObject {
        case let cellObject as BridgeCheckmarkCellObject:
            bridgeDirector.selectedBridge = cellObject.type
            let sectionObjects = factory.sectionObjects()
            viewInput?.update(with: sectionObjects)
        case is OnionySubtitleCellObject:
            viewInput?.showCustomBridgeInput()
        default:
            break
        }
    }
    
    func customBridgeDidSelect(_ data: BridgeData) {
        bridgeDirector.selectedBridge = .custom(data)
        let sectionObjects = factory.sectionObjects()
        viewInput?.update(with: sectionObjects)
    }
}
