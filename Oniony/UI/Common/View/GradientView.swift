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

/// Основной градиент приложения.
final class GradientView: UIView {
    
    /// Цвет начала градиента. По-умолчанию, основной цвет приложения.
    @IBInspectable var firstColor: UIColor = Asset.main.color
    
    /// Цвет конца градиента. По-умолчанию, побочный цвет приложения.
    @IBInspectable var secondColor: UIColor = Asset.second.color
    
    private var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(origin: .zero, size: frame.size)
        layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Public
    
    /// Обновляет точки начала и конца градиента.
    func updatePoints(start: ViewSide, end: ViewSide) {
        gradient.startPoint = start.point
        gradient.endPoint = end.point
    }
    
    /// Меняет цвета градиента местами,
    func swapColors() {
        swap(&firstColor, &secondColor)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
    }
    
    /// Показать градиент.
    func showGradient() {
        layer.insertSublayer(gradient, at: 0)
    }
    
    /// Скрыть градиент.
    func hideGradient() {
        gradient.removeFromSuperlayer()
    }
}
