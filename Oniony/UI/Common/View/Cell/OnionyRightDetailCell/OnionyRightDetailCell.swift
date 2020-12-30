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

/// Модель ячейки с детялями справа.
struct OnionyRightDetailCellObject: CellObject {
    
    /// Заголовок.
    let title: String
    
    /// Детали.
    let detail: String
    
    /// Активна ли ячеека.
    let isEnabled: Bool
    
    /// Стандартный конструктор.
    init(
        title: String,
        detail: String,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.detail = detail
        self.isEnabled = isEnabled
    }
}

/// Стандартизированная ячейка с деталями справа.
final class OnionyRightDetailCell: UITableViewCell {
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var detail: UILabel!
    
    /// Обновить ячейку с помощью модели.
    func update(with cellObject: OnionyRightDetailCellObject) {
        title.text = cellObject.title
        detail.text = cellObject.detail
        
        let textColor = cellObject.isEnabled ? UIColor.white : Asset.secondaryText.color
        title.textColor = textColor
        detail.textColor = textColor
    }
}
