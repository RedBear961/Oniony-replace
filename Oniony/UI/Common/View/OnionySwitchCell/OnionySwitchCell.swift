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

/// Модель данных ячейки с переключаталем.
struct OnionySwitchCellObject: CellObject {
    
    /// Заголовок.
    let title: String
    
    /// Подзаголовок.
    let subtitle: String
    
    /// Состояние переключателя.
    let isOn: Bool
}

/// Ячейка таблицы, содержащая переключатель.
final class OnionySwitchCell: UITableViewCell {
    
    /// Блок обратного вызова.
    typealias ActionBlock = (OnionySwitchCell, _ isOn: Bool) -> Void
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var switchButton: UISwitch!
    
    private var onSwitch: ActionBlock?
    
    /// Обновновляет ячейку с помощью модели данных и обратного вызова.
    func update(
        with cellObject: OnionySwitchCellObject,
        onSwitch: @escaping ActionBlock
    ) {
        self.title.text = cellObject.title
        self.subtitle.text = cellObject.subtitle
        self.switchButton.isOn = cellObject.isOn
        self.onSwitch = onSwitch
    }
    
    @IBAction func switchDidTouch(_ sender: UISwitch) {
        onSwitch?(self, sender.isOn)
    }
}
