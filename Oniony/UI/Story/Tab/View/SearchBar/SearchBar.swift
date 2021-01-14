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

protocol SearchBarDelegate: AnyObject {
    
    func searchContainer(for searchBar: SearchBar) -> UIView
}

final class SearchBar: ViewContainer {
    
    @IBOutlet private var tabButton: UIButton!
    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var searchBackground: UIView!
    @IBOutlet private var leftImage: UIImageView!
    @IBOutlet private var textField: UITextField!
    
    private let gradient = CAGradientLayer()
    
    weak var delegate: SearchBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Asset.lightBackground.color
        
        tabButton.layer.borderWidth = 2
        tabButton.layer.borderColor = UIColor.white.cgColor
        tabButton.layer.cornerRadius = 4
        
        searchBackground.layer.cornerRadius = 10
        
        gradient.colors = [Asset.second.color.cgColor, Asset.main.color.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(origin: .zero, size: frame.size)
        layer.insertSublayer(gradient, at: 0)
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите запрос или адрес",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
    }
    
    @discardableResult
    override func endEditing(_ force: Bool) -> Bool {
        return textField.endEditing(force)
    }
}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        gradient.removeFromSuperlayer()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.insertSublayer(gradient, at: 0)
    }
}
