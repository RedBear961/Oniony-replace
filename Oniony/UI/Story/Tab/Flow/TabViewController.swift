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
    
    func update(with tab: Tab, tabCount: Int)
}

final class TabViewController: ViewController, TabViewInput {
    
    @IBOutlet private var searchBar: SearchBar!
    @IBOutlet private var webContainer: UIView!
    
    var viewOutput: TabViewOutput!
    var tab: Tab!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
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
        
        self.tab = tab
        self.tab.webview.removeFromSuperview()
        webContainer.addSubview(tab.webview)
        tab.webview.autoPinEdgesToSuperviewEdges()
        tab.delegate = self
    }
}

extension TabViewController: SearchBarDelegate {
    
    func searchContainer(for searchBar: SearchBar) -> UIView {
        return webContainer
    }
}

extension TabViewController: TabDelegate {
    
    func tab(_ tab: Tab, didUpdate progress: CGFloat) {
        searchBar.update(with: progress)
    }
}
