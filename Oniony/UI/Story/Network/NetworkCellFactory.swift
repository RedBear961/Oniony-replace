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

/// Протокол фабрики ячеек модуля настройки сети.
protocol NetworkCellFactory {
    
    /// Создает модели секций таблицы.
    func sectionObjects() -> [NetworkSectionObject]
}

/// Фабрика ячеек модуля настройки сети.
final class NetworkCellFactoryImpl: NetworkCellFactory {
    
    private let bridgeStorage: BridgeStorage
    
    init(bridgeStorage: BridgeStorage) {
        self.bridgeStorage = bridgeStorage
    }
    
    // MARK: - NetworkCellFactory
    
    func sectionObjects() -> [NetworkSectionObject] {
        var sectionObjects = [NetworkSectionObject]()
        
        let statusCellObjects = [
            OnionyRightDetailCellObject(
                title: L10n.Network.netowrkStatus,
                detail: L10n.Network.no
            ),
            OnionyRightDetailCellObject(
                title: L10n.Network.torStatus,
                detail: L10n.Network.disconnected
            ),
            OnionyRightDetailCellObject(
                title: L10n.Network.bridgeStatus,
                detail: bridgeStorage.isEnabled ? L10n.Network.yes : L10n.Network.no
            )
        ]
        let statusSection = NetworkSectionObject(
            header: L10n.Network.Tableview.Header.currentStatus,
            footer: L10n.Network.Tableview.Footer.oniony,
            cellObjects: statusCellObjects
        )
        sectionObjects.append(statusSection)
        
        let configureSection = NetworkSectionObject(
            header: nil,
            footer: nil,
            cellObjects: [
                OnionySubtitleCellObject(
                    image: Asset.iconWrench.image,
                    title: L10n.Network.bridgeConfiguration,
                    subtitle: L10n.Network.bridgeDescription
                )
        ])
        sectionObjects.append(configureSection)
        
        return sectionObjects
    }
}
