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

protocol TabViewInput: AnyObject {
    
    /// Обновить содержимое с помощью модели вкладки и общим количеством вкладок.
    func update(with tab: Tab, tabCount: Int)
    
    func searchContainer() -> UIView
}

final class TabViewController: ViewController, TabViewInput {
    
    @IBOutlet private var searchBar: SearchBar!
    @IBOutlet private var webContainer: UIView!
    
    var viewOutput: TabViewOutput!
    var tab: Tab?
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = viewOutput
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewOutput.moduleWillAppear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    // MARK: - TabViewInput
    
    func update(with tab: Tab, tabCount: Int) {
        searchBar.update(with: tabCount)
        
        self.tab?.webview.removeFromSuperview()
        self.tab?.delegate = nil
        self.tab = tab
        
        webContainer.addSubview(tab.webview)
        tab.webview.autoPinEdgesToSuperviewEdges()
        tab.delegate = self
    }
    
    func searchContainer() -> UIView {
        return webContainer
    }
}

extension TabViewController: TabDelegate {
    
    func tab(_ tab: Tab, didUpdate progress: CGFloat) {
        searchBar.update(with: progress)
    }
}
