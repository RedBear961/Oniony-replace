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

protocol NetworkViewOutput {
    
    func moduleDidLoad()
}

final class NetworkPresenter: NetworkViewOutput {
    
    private weak var viewInput: NetworkViewInput?
    private let coordinator: NetworkCoordinating
    
    init(
        viewInput: NetworkViewInput,
        coordinator: NetworkCoordinating
    ) {
        self.viewInput = viewInput
        self.coordinator = coordinator
    }
    
    // MARK: - NetworkViewOutput
    
    func moduleDidLoad() {
        var sectionObjects = [NetworkSectionObject]()
        sectionObjects.append(NetworkSectionObject(header: "Текущий статус", footer: "Oniony перенаправляет ваш трафик через сеть Tor. Ее поддерживают тысячи добровольцев по всему миру.", cellObjects: [ // swiftlint:disable:this all
            KeyValueCellObject(key: "Готовность Tor", value: "Нет"),
            KeyValueCellObject(key: "Состояние", value: "Отключен"),
            KeyValueCellObject(key: "Мосты включены", value: "Нет")
        ]))
        
        sectionObjects.append(NetworkSectionObject(header: nil, footer: nil, cellObjects: [
            OnionyTableViewCellObject(image: Asset.iconWrench.image, title: "Конфигурация моста", subtitle: "Используйте мост для подключения к Tor")
        ]))
        
        viewInput?.update(with: sectionObjects)
    }
}
