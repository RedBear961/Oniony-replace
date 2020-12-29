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

protocol StartUpViewInput: AnyObject {
    
    /// Показать прогресс запуска тор-сети.
    func showProgress()
    
    /// Обновить статус запуска тор-сети.
    func update(with status: TorLoadingStatus)
}

final class StartUpViewController: UIViewController, StartUpViewInput {
    
    @IBOutlet private var startUpView: StartUpView!
    @IBOutlet private var startUpLogView: StartUpLogView!
    @IBOutlet private var scrollView: UIScrollView!
    
    var viewOutput: StartUpViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = view.frame.size
        
        startUpView.bind(
            onSettings: viewOutput.settingDidTouch,
            onConnect: viewOutput.connectDidTouch
        )
    }
    
    // MARK: - StartUpViewInput
    
    // Показать прогресс запуска тор-сети.
    func showProgress() {
        startUpView.showProgress()
    }
    
    // Обновить статус запуска тор-сети.
    func update(with status: TorLoadingStatus) {
        startUpView.update(with: status)
    }
}
