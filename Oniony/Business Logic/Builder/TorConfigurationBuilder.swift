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

import Tor
import IPtProxy

/// Протокол билдера конфигурации подключения тор-сети.
protocol TorConfiguratorBuilding {
    
    /// Включен ли режим откладки.
    var isDebug: Bool { get set }
    
    /// Создает конфигурацию тор-сети по-умолчанию.
    func configuration(for data: TorConfigurationData) -> TorConfiguration
}

/// Билдер конфигурации подключения тор-сети.
final class TorConfigurationBuilder: TorConfiguratorBuilding {
    
    private let fileManager: FileManager
    private let bundle: Bundle
    private let bridgeDirector: BridgeDirecting
    
    init(
        fileManager: FileManager,
        bundle: Bundle = .main,
        bridgeDirector: BridgeDirecting
    ) {
        self.fileManager = fileManager
        self.bundle = bundle
        self.bridgeDirector = bridgeDirector
    }
    
    // MARK: - TorConfiguratorBuilding
    
    // Включен ли режим откладки.
    var isDebug: Bool = true
    
    // Создает конфигурацию тор-сети по-умолчанию.
    func configuration(for data: TorConfigurationData) -> TorConfiguration {
        guard let docDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Не удалось получить доступ к директории документов.")
        }

        let dataDirectory = URL(fileURLWithPath: docDirectory.path, isDirectory: true).appendingPathComponent("tor", isDirectory: true)

        try? fileManager.createDirectory(
            atPath: dataDirectory.path,
            withIntermediateDirectories: true,
            attributes: nil
        )

        let authDirectory = URL(fileURLWithPath: dataDirectory.path, isDirectory: true).appendingPathComponent("auth", isDirectory: true)

        try? fileManager.createDirectory(
            atPath: authDirectory.path,
            withIntermediateDirectories: true,
            attributes: nil
        )

        let configuration = TorConfiguration()
        configuration.cookieAuthentication = true
        configuration.dataDirectory = dataDirectory
        
        let logMethod = isDebug ? "notice stdout" : "notice file /dev/null"
        
        guard let geoip = bundle.path(forResource: "geoip", ofType: nil),
              let geoip6 = bundle.path(forResource: "geoip6", ofType: nil) else {
            preconditionFailure("Файлы с данных о IP должны существовать!")
        }

        // TODO: Вынести все ключи в константы. Возможно даже сделать типобезопасные функции.
        var arguments = [
            "--allow-missing-torrc",
            "--ignore-missing-torrc",
            "--clientonly", "1",
            "--AvoidDiskWrites", "1",
            "--socksport", "\(data.socksPort)",
            "--controlport", "127.0.0.1:\(data.controlPort)",
            "--log", logMethod,
            "--clientuseipv6", "0",
            "--ClientTransportPlugin", "obfs4 socks5 127.0.0.1:\(IPtProxyObfs4SocksPort)",
            "--ClientTransportPlugin", "meek_lite socks5 127.0.0.1:\(IPtProxyMeekSocksPort)",
            "--ClientTransportPlugin", "snowflake socks5 127.0.0.1:\(IPtProxySnowflakeSocksPort)",
            "--ClientOnionAuthDir", authDirectory.path,
            "--GeoIPFile", geoip,
            "--GeoIPv6File", geoip6
        ]
        
        if let bridge = bridgeDirector.selectedBridge {
            arguments = append(bridge: bridge, to: arguments)
        }

        configuration.arguments = arguments
        return configuration
    }
    
    // MARK: - Private
    
    // Добавляет информацию о мостах в аргументы запуска.
    private func append(bridge: Bridge, to arguments: [String]) -> [String] {
        var arguments = arguments
        
        arguments.append("--usebridges")
        arguments.append("1")
        
        let data = bridge.data(isIPv6: false)
        data.forEach { (element) in
            arguments.append("--bridge")
            arguments.append(element)
        }
        
        return arguments
    }
}
