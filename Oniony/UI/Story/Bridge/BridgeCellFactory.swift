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

/// Протокол фабрики ячеек модуля настройки мостов.
protocol BridgeCellFactory {
    
    /// Создает модели секций таблицы.
    func sectionObjects() -> [BridgeSectionObject]
}

/// Фабрика ячеек модуля настройки мостов.
final class BridgeCellFactoryImpl: BridgeCellFactory {
    
    private let bridgeStorage: BridgeStorage
    
    init(bridgeStorage: BridgeStorage) {
        self.bridgeStorage = bridgeStorage
    }
    
    // MARK: - BridgeCellFactory
    
    func sectionObjects() -> [BridgeSectionObject] {
        var sectionObjects = [BridgeSectionObject]()
        let isEnabledBridge = bridgeStorage.isEnabled
        
        var selectionCellObjects: [CellObject] = [
            OnionySwitchCellObject(
                title: L10n.Bridge.useBridge,
                subtitle: L10n.Bridge.configureBridge,
                isOn: isEnabledBridge
            )
        ]
        
        if let bridge = bridgeStorage.selectedBridge {
            selectionCellObjects += [
                /*
                BridgeCheckmarkCellObject(
                    title: Bridge.obfs4.name,
                    isSelected: bridge == .obfs4,
                    type: .obfs4
                ),
                BridgeCheckmarkCellObject(
                    title: Bridge.meekAmazon.name,
                    isSelected: bridge == .meekAmazon,
                    type: .meekAmazon
                ),
                BridgeCheckmarkCellObject(
                    title: Bridge.meekAzure.name,
                    isSelected: bridge == .meekAzure,
                    type: .meekAzure
                ),
                */
                BridgeCheckmarkCellObject(
                    title: Bridge.snowflake.name,
                    isSelected: bridge == .snowflake,
                    type: .snowflake
                ),
                OnionySubtitleCellObject(
                    image: nil,
                    title: L10n.Bridge.specifyBridge,
                    subtitle: L10n.Bridge.specifyBridgeData
                )
            ]
        }
        
        let selectionSection = BridgeSectionObject(
            footer: L10n.Bridge.TableView.Header.aboutBridges,
            cellObjects: selectionCellObjects
        )
        sectionObjects.append(selectionSection)
        
        let bridgeDetail = bridgeStorage.selectedBridge?.name ?? L10n.Bridge.notConfigured
        let statusSection = BridgeSectionObject(
            footer: nil,
            cellObjects: [
                OnionyRightDetailCellObject(
                    title: L10n.Bridge.currentBridge,
                    detail: bridgeDetail,
                    isEnabled: isEnabledBridge
                )
        ])
        sectionObjects.append(statusSection)
        
        return sectionObjects
    }
}
