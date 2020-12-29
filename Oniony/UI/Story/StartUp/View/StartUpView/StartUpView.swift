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

/// Отображение запуска тор-сети.
final class StartUpView: ViewContainer {
    
    @IBOutlet private var connectButton: OnionyButton!
    @IBOutlet private var progressTitle: UILabel!
    @IBOutlet private var summaryTitle: UILabel!
    
    private var onSettings: EmptyBlock?
    private var onConnect: EmptyBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressTitle.text = ""
        summaryTitle.text = ""
    }
    
    // MARK: - Public
    
    func bind(
        onSettings: @escaping EmptyBlock,
        onConnect: @escaping EmptyBlock
    ) {
        self.onSettings = onSettings
        self.onConnect = onConnect
    }
    
    func showProgress() {
        connectButton.isHidden = true
        progressTitle.isHidden = false
        summaryTitle.isHidden = false
    }
    
    func update(with data: TorLoadingStatus) {
        progressTitle.text = "\(data.progress)%"
        summaryTitle.text = data.summary
    }
    
    // MARK: - Action
    
    @IBAction func settingDidTouch(_ sender: Any) {
        onSettings?()
    }
    
    @IBAction func connectDidTouch(_ sender: Any) {
        onConnect?()
    }
}
