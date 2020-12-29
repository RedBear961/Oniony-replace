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
import PureLayout

/// Абстрактный контейнер отображения.
///
/// Наследуйте от него и создайте одноимменный XIB-файл. Контент XIB-файла будет загружен
/// в свойство `content` и расположен на всей доступной площади отображения.
/// Вы также можете добавить любые аутлеты или действия в наследника.
class ViewContainer: UIView {
    
    /// Контент XIB-файла, которым управляет данный контейнер.
    var content: UIView!
    
    /// Имя XIB-файла, если наследник использует XIB своего суперкласса.
    var nibName: String? { return nil }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustContent()
    }
    
    // Добавляет контент на отображение.
    private func adjustContent() {
        guard type(of: self) != ViewContainer.self else {
            fatalError("You must inherit from the ViewContainer and create a similar XIB.")
        }
        
        backgroundColor = .clear
        layer.masksToBounds = false
        
        content = loadContent()
        addSubview(content)
        content.autoPinEdgesToSuperviewEdges()
        self.prepareForDisplay()
    }
    
    // Загружает контент из XIB-файла.
    private func loadContent() -> UIView {
        let nibName = self.nibName ?? String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        let content = nib.instantiate(withOwner: self)
        
        guard let result = content.first as? UIView else {
            fatalError("The view obtained from XIB does not match of type \(UIView.self)")
        }
        
        return result
    }
    
    // MARK: Life cycle
    
    func prepareForDisplay() {
        // Переопределите функцию для настройки.
    }
}
