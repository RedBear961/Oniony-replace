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

/// Протокола директора мостов тор-сети.
protocol BridgeStorage: AnyObject {
    
    /// Включены ли мосты.
    var isEnabled: Bool { get set }
    
    /// Текущий выбранный мост.
    var selectedBridge: Bridge? { get set }
}

/// Директор мостов тор-сети.
final class BridgeStorageImpl: BridgeStorage {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        guard let id = userDefaults.bridgeId else { return }
        let data = userDefaults.bridgeData
        selectedBridge = Bridge(id: id, data: data)
    }
    
    // MARK: - BridgeStorage
    
    var isEnabled: Bool {
        set { selectedBridge = newValue ? .default : nil }
        get { return selectedBridge != nil }
    }
    
    var selectedBridge: Bridge? {
        didSet { updateStorage() }
    }
    
    // MARK: - Private
    
    private func updateStorage() {
        userDefaults.bridgeData = nil
        
        guard let bridge = selectedBridge else {
            userDefaults.bridgeId = nil
            return
        }
        
        switch bridge {
        case .custom(let data):
            userDefaults.bridgeData = data
            fallthrough
        default:
            userDefaults.bridgeId = bridge.id
        }
    }
}

private extension UserDefaults {
    
    private enum Keys {
        
        // Ключ идентификатора моста.
        static let id = "bridgeId"
        
        // Ключ данных моста.
        static let data = "bridgeData"
    }
    
    /// Идентификатор текущего активного моста.
    var bridgeId: String? {
        set { setValue(newValue, forKey: Keys.id ) }
        get { string(forKey: Keys.id) }
    }
    
    /// Данные текущего активного моста.
    var bridgeData: BridgeData? {
        set { setValue(newValue, forKey: Keys.data ) }
        get { stringArray(forKey: Keys.data) }
    }
}
