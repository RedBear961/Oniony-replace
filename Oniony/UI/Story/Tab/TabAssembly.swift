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

import Swinject

final class TabAssembly: AutoAssembly {
    
    dynamic func tabViewController() {
        container.register(
            TabViewController.self
        ) { (resolver, coordinator: TabCoordinating) -> TabViewController in
            let controller = StoryboardScene.Tab.tabViewController.instantiate()
            controller.viewOutput = resolver.resolve(
                TabViewOutput.self,
                arguments: controller as TabViewInput, coordinator
            )!
            return controller
        }
    }
    
    dynamic func tabPresenter() {
        container.register(
            TabViewOutput.self
        ) { (resolver, viewInput: TabViewInput, coordinator: TabCoordinating) -> TabPresenter in
            return TabPresenter(
                viewInput: viewInput,
                coordinator: coordinator,
                tabManager: resolver.resolve(TabDirecting.self)!
            )
        }
    }
    
    dynamic func tabCoordinator() {
        container.register(
            TabCoordinating.self
        ) { (resolver, navigationVC: UINavigationController) -> TabCoordinator in
            return TabCoordinator(resolver, presentationVC: navigationVC)
        }
    }
}
