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

/// Псевдоним данных о мосте.
typealias BridgeData = [String]

/// Мост тор-сети.
// FIXME: Заставить работать мосты и кроме snowflake
enum Bridge: Equatable {
    
    /// Протокол обфускации `obfs4`.
    case obfs4
    
    /// Протокол, использующий сервисы Amazon, для видимости белого трафика.
    case meekAmazon
    
    /// Протокол, использующий сервисы Azure, для видимости белого трафика.
    case meekAzure
    
    /// Мосты `Snowflake`.
    case snowflake
    
    /// Пользовательский мост.
    case custom(BridgeData)
    
    /// Мост по-умолчанию.
    static var `default`: Bridge {
        return Bridge.obfs4
    }
}

extension Bridge {
    
    /// Имя моста.
    var name: String {
        switch self {
        case .obfs4:
            return "obfs4"
        case .meekAmazon:
            return "meek-amazone"
        case .meekAzure:
            return "meek-azure"
        case .snowflake:
            return "snowflake"
        case .custom(_):
            return "Пользовательский"
        }
    }
    
    /// Данные о мосте для указанного типа.
    /// - Parameter isIPv6: Использует ли клиент IP версии 6.
    func data(isIPv6: Bool) -> BridgeData {
        switch self {
        case .obfs4:
            return isIPv6 ? BridgeDataProvider.obfs4 : BridgeDataProvider.obfs4IPv6
        case .meekAmazon:
            return BridgeDataProvider.meekAmazon
        case .meekAzure:
            return BridgeDataProvider.meekAzure
        case .snowflake:
            return BridgeDataProvider.snowflake
        case .custom(let data):
            return data
        }
    }
}

extension Bridge {
    
    struct BridgeId {
        
        /// Идентификатор моста `obfs4`.
        static var obfs4: String { return "obfs4" }
        
        /// Идентификатор моста `meekAmazon`.
        static var meekAmazon: String { return "meek_amazone" }
        
        /// Идентификатор моста `meekAzure`.
        static var meekAzure: String { return "meek_azure" }
        
        /// Идентификатор моста `snowflake`.
        static var snowflake: String { return "snowflake" }
        
        /// Идентификатор пользовательского моста.
        static var custom: String { return "custom" }
    }
    
    /// Идентификатор типа моста.
    var id: String {
        switch self {
        case .obfs4:
            return "obfs4"
        case .meekAmazon:
            return "meek_amazone"
        case .meekAzure:
            return "meek_azure"
        case .snowflake:
            return "snowflake"
        case .custom(_):
            return "custom"
        }
    }
    
    /// Конструктор моста по идентификатору и набору данных.
    /// Для встроенных мостов, данные не будут использованы.
    /// Для пользовательских мостов данные необходимы, в случае
    /// их отсутствия будет выбран мост по-умолчанию.
    init(id: String, data: BridgeData?) {
        switch id {
        case BridgeId.obfs4:        self = .obfs4
        case BridgeId.meekAmazon:   self = .meekAmazon
        case BridgeId.meekAzure:    self = .meekAzure
        case BridgeId.snowflake:    self = .snowflake
        case BridgeId.custom:
            guard let data = data else { fallthrough }
            self = .custom(data)
        default:
            self = .default
        }
    }
}

/// Провайдер данных о мостах.
struct BridgeDataProvider {
    
    // swiftlint:disable line_length
    
    /// Мосты `obfs4`.
    static var obfs4: [String] {
        let url = Bundle.main.url(forResource: "obfs4", withExtension: "plist")!
        let obfs4 = NSArray(contentsOf: url) as! [String] // swiftlint:disable:this force_cast
        return obfs4
    }
    
    /// Мосты `obfs4` для клиентов, использующих IP версии 6.
    static let obfs4IPv6 = [
        "obfs4 [2001:470:b381:bfff:216:3eff:fe23:d6c3]:443 CDF2E852BF539B82BD10E27E9115A31734E378C2 cert=qUVQ0srL1JI/vO6V6m/24anYXiJD3QP2HgzUKQtQ7GRqqUvs7P+tG43RtAqdhLOALP7DJQ iat-mode=1"
    ]
    
    /// Мосты `Amazon`.
    static let meekAmazon = [
        "meek_lite 0.0.2.0:2 B9E7141C594AF25699E0079C1F0146F409495296 url=https://d2cly7j4zqgua7.cloudfront.net/ front=a0.awsstatic.com"
    ]
    
    /// Мосты `Azure`.
    static let meekAzure = [
        "meek_lite 0.0.2.0:3 97700DFE9F483596DDA6264C4D7DF7641E1E39CE url=https://meek.azureedge.net/ front=ajax.aspnetcdn.com"
    ]
    
    /// Мосты `Snowflake`. Зарезервированный адрес.
    static let snowflake = [
        "snowflake 192.0.2.3:1"
    ]
    
    // swiftlint:enable line_length
}
