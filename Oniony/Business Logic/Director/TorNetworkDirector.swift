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

enum TorState {
    
    case none
    case started
    case connected
    case stopped
}

/// Протокол директора тор-сети.
protocol TorNetworkDirecting: AnyObject {
    
    /// Делегат директора тор-сети.
    var delegate: TorNetworkDirectorDelegate? { get set }
    
    // Состояние подключения.
    var state: TorState { get }
    
    /// Запускает тор-сеть.
    func startTor()
}

/// Делегат директора тор-сети.
protocol TorNetworkDirectorDelegate: AnyObject {
    
    /// Был обновлен статус подключения тор-сети.
    func torDirector(_ director: TorNetworkDirecting, didUpdate status: TorLoadingStatus)
    
    /// Тор-сеть была запущена.
    func torDirectorDidLoad(_ director: TorNetworkDirecting)
    
    /// Во время запуска тор-сети произрошла ошибка и дальнейшее подключение невозможно.
    func torDirector(_ director: TorNetworkDirecting, didFinishWith error: Error)
}

/// Директор тор-сети. Этот класс является синглтоном.
final class TorNetworkDirector: TorNetworkDirecting {
    
    private let configurationBuilder: TorConfiguratorBuilding
    private let configurationData: TorConfigurationData
    private let torController: TorController
    private var torThread: TorThread?
    private var torConfiguration: TorConfiguration?
    
    #if DEBUG
    
    // Дебаг режим. В нем тор-сеть не запускается, а делегат
    // получает сообщение об удачном запуске.
    private let isDebug: Bool = true
    
    #endif
    
    init(
        configurationBuilder: TorConfiguratorBuilding,
        configurationData data: TorConfigurationData
    ) {
        self.configurationBuilder = configurationBuilder
        self.torController = TorController(socketHost: "127.0.0.1", port: data.controlPort)
        self.configurationData = data
    }
    
    // MARK: - TorNetworkDirecting
    
    // Делегат.
    weak var delegate: TorNetworkDirectorDelegate?
    
    // Статус подключения.
    var isConnect: Bool = false
    
    // Состояние подключения.
    var state: TorState = .none
    
    // Запускает тор-сеть.
    func startTor() {
        state = .started
        
        #if DEBUG
        
        if isDebug {
            state = .connected
            delegate?.torDirectorDidLoad(self)
            return
        }
        
        #endif
        
        if torThread == nil || (torThread?.isCancelled ?? true) {
            let configuration = configurationBuilder.configuration(for: configurationData)
            torThread = TorThread(configuration: configuration)
            self.torConfiguration = configuration
        }
        
        guard let thread = torThread,
              let configuration = torConfiguration else {
            preconditionFailure("Поток и конфигурация тор-сети должны существовать!")
        }
        
        thread.start()
        
        // FIXME: Вынести все это в отдельный класс.
        IPtProxyStartSnowflake(
            "stun:stun.l.google.com:19302", "https://snowflake-broker.azureedge.net/",
            "ajax.aspnetcdn.com", nil, true, false, true, 3
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do { try self.authenticate(with: configuration) } catch {
                self.state = .stopped
                self.delegate?.torDirector(self, didFinishWith: error)
            }
        }
    }
    
    // MARK: - Private
    
    // Аутентифицирует клиента в сети.
    private func authenticate(with configuration: TorConfiguration) throws {
        try self.torController.connect()
        
        guard let dataDirectory = configuration.dataDirectory else {
            preconditionFailure("Не удалось получить URL директории с данными!")
        }
        
        let cookieURL = dataDirectory.appendingPathComponent("control_auth_cookie")
        let cookie = try Data(contentsOf: cookieURL)
        
        self.torController.authenticate(with: cookie, completion: { (success, _) in
            guard success else { return }
            
            // Наблюдатель построения цепочки узлов.
            var circuitObserver: Any?
            circuitObserver = self.torController.addObserver { (established) in
                if established {
                    self.torController.removeObserver(circuitObserver)
                }
            }
            
            // Наблюдатель статуса загрузки тор-сети.
            var statusObserver: Any?
            statusObserver = self.torController.addObserver { (type, _, action, arguments) -> Bool in
                guard type == "STATUS_CLIENT",
                      action == "BOOTSTRAP",
                      let arguments = arguments,
                      let status = TorLoadingStatus(arguments) else {
                    return false
                }
                
                self.delegate?.torDirector(self, didUpdate: status)

                if status.progress >= 100 {
                    self.state = .connected
                    self.torController.removeObserver(statusObserver)
                    self.delegate?.torDirectorDidLoad(self)
                }
                
                return true
            }
        })
    }
}
