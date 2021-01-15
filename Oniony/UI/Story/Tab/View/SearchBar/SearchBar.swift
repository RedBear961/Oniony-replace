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

/// Делегат поискового бара.
protocol SearchBarDelegate: AnyObject {
    
    /// Контейнер, на котором будут отображаться поисковые подсказки и элементы управления поиском.
    func searchContainer(for searchBar: SearchBar) -> UIView
}

/// Поисковый бар.
final class SearchBar: ViewContainer {
    
    @IBOutlet private var tabButton: UIButton!
    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var searchBackground: UIView!
    @IBOutlet private var leftImage: UIImageView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var gradient: GradientView!
    
    private var searchContainer: SearchContainer?
    
    /// Делегат поискового бара.
    weak var delegate: SearchBarDelegate?
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Asset.lightBackground.color
        
        tabButton.updateBorder(color: .white, width: 2)
        
        gradient.swapColors()
        gradient.updatePoints(start: .leftCenter, end: .rightCenter)
        
        addShadow(
            color: UIColor.black.withAlphaComponent(0.2),
            offset: CGSize(width: 0, height: 4),
            radius: 8
        )
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите запрос или адрес",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
    }
    
    @discardableResult
    override func endEditing(_ force: Bool) -> Bool {
        return textField.endEditing(force)
    }
    
    // MARK: - Private
}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        backgroundColor = Asset.darkBackground.color
        gradient.backgroundColor = Asset.lightBackground.color
        gradient.hideGradient()
        
        guard let container = delegate?.searchContainer(for: self) else {
            preconditionFailure("Должен быть предоставлен поисковый контейнер!")
        }
        
        let searchContainer = SearchContainer()
        container.addSubview(searchContainer)
        searchContainer.autoPinEdgesToSuperviewEdges()
        self.searchContainer = searchContainer
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        backgroundColor = Asset.lightBackground.color
        gradient.backgroundColor = .clear
        gradient.showGradient()
        
        searchContainer?.removeFromSuperview()
        searchContainer = nil
    }
}
