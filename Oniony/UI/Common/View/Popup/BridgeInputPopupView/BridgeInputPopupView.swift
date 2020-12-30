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

/// Попап ручного ввода моста.
final class BridgeInputPopupView: ViewContainer {
    
    /// Блок завершения операции ввода.
    typealias DoneBlock = (String?) -> Void
    
    @IBOutlet var textField: UITextField!
    
    private var onCancel: EmptyBlock?
    private var onDone: DoneBlock?
    
    /// Обновляет попап с помощью обратнызх вызовов.
    func update(
        onCancel: @escaping EmptyBlock,
        onDone: @escaping DoneBlock
    ) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Asset.headerText.color.cgColor
        textField.layer.cornerRadius = 8
        
        self.onCancel = onCancel
        self.onDone = onDone
    }
    
    // MARK: - Action
    
    @IBAction func cancelDidTouch(_ sender: Any) {
        onCancel?()
    }
    
    @IBAction func doneDidTouch(_ sender: Any) {
        onDone?(textField.text)
    }
}
