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

/// Псевдоним, чтобы XCode не выдавал варнинг на каждое обращение к UIWebView.
typealias WebView = UIWebView

private let kWebProgressEstimatedProgressKey = "WebProgressEstimatedProgressKey"
private let kWebProgressEstimateChangedKeyPath = "documentView.webView"

/// Делегат вкладки.
protocol TabDelegate: AnyObject {
    
    /// Прогресс загрузкит страницы был обновлен.
    func tab(_ tab: Tab, didUpdate progress: CGFloat)
}

/// Модель веб-вкладки.
final class Tab {
    
    /// Веб-отображение страницы.
    let webview: WebView
    
    /// Контроллер перезагрузки страницы.
    let refreshControl: UIRefreshControl
    
    /// Прогресс загрузки страницы.
    private(set) var progress: CGFloat
    
    /// Делегат вкладки.
    weak var delegate: TabDelegate?
    
    /// Создает новую вкладку.
    /// - Parameters:
    ///   - style: Стиль открытия новой вкладки.
    ///   - homePage: URL домашней страницы..
    init(style: NewTabStyle, homePage: URL) {
        self.webview = WebView()
        self.refreshControl = UIRefreshControl()
        self.progress = 0.2
        
        setup(for: style, homePage: homePage)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(progressDidChange(_:)),
            name: .webProgressEstimateChangedNotification,
            object: webview.value(forKeyPath: kWebProgressEstimateChangedKeyPath)
        )
    }
    
    // MARK: - Public
    
    /// Перезагружает страницу.
    @objc func reload() {
        webview.reload()
    }
    
    // MARK: - Private
    
    // Настраивает UIWebView.
    private func setup(for style: NewTabStyle, homePage: URL) {
        webview.backgroundColor = Asset.codGray.color
        webview.isOpaque = false
        
        if style == .home {
            let request = URLRequest(url: homePage)
            webview.loadRequest(request)
        }
        
        refreshControl.addTarget(
            self,
            action: #selector(reload),
            for: .valueChanged
        )
        refreshControl.attributedTitle = NSAttributedString(
            string: L10n.Tab.pullToRefresh,
            attributes: [
                .foregroundColor: UIColor.white
            ]
        )
        refreshControl.tintColor = .white
        webview.scrollView.refreshControl = refreshControl
    }
    
    // Прогресс загрузки страницы был обновлен.
    @objc private func progressDidChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let progress = userInfo[kWebProgressEstimatedProgressKey] as? CGFloat else { return }
        
        self.progress = progress
        delegate?.tab(self, didUpdate: progress)
        
        if abs(1 - progress) < .ulpOfOne {
            refreshControl.endRefreshing()
        }
    }
}

private extension NSNotification.Name {
    
    /// Нотификация об изменении прогресса загрузки веб-страницы.
    static var webProgressEstimateChangedNotification: NSNotification.Name {
        return .init(rawValue: "WebProgressEstimateChangedNotification")
    }
}
