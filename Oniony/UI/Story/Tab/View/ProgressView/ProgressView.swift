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

/// Отображение прогресса загрузки страницы.
final class ProgressView: UIView {
    
    /// Текущий прогресс загрузки.
    private(set) var progress: CGFloat = 0
    
    private let progressContainer = _ProgressContainer()
    private var containerWidth: NSLayoutConstraint?
    
    override func awakeFromNib() {
        progressContainer.backgroundColor = Asset.lightBackground.color
        addSubview(progressContainer)
        progressContainer.autoPinEdgesToSuperviewEdges(
            with: .zero, excludingEdge: .trailing
        )
        updateProgress(progress, animated: false)
    }
    
    /// Обнововляет прогресс.
    func updateProgress(_ progress: CGFloat, animated: Bool = true) {
        self.progress = progress
        containerWidth?.autoRemove()
        containerWidth = progressContainer.autoConstrainAttribute(
            .width,
            to: .width,
            of: self,
            withMultiplier: progress
        )
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.setNeedsLayout()
        }
    }
}

// Приватный контейнер градиента загрузки.
private final class _ProgressContainer: UIView {
    
    private let gradient: CAGradientLayer
    
    override init(frame: CGRect) {
        gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "636FFF").cgColor,
            UIColor(hex: "8C51E3").cgColor,
            UIColor(hex: "DD0091").cgColor,
            UIColor(hex: "FF0044").cgColor,
            UIColor(hex: "FF8A00").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        super.init(frame: frame)
        
        layer.addSublayer(gradient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        gradient.frame = CGRect(
            origin: .zero,
            size: layer.bounds.size
        )
    }
}
