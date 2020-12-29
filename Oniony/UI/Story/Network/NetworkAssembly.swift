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

final class NetworkAssembly: AutoAssembly {
    
    dynamic func networkViewController() {
        container.register(
            NetworkViewController.self
        ) { (resolver, coordinator: NetworkCoordinating) -> NetworkViewController in
            let controller = StoryboardScene.Network.networkViewController.instantiate()
            controller.viewOutput = resolver.resolve(
                NetworkViewOutput.self,
                arguments: controller as NetworkViewInput, coordinator
            )!
            return controller
        }
    }
    
    dynamic func networkPresenter() {
        container.register(
            NetworkViewOutput.self
        ) { (_, viewInput: NetworkViewInput, coordinator: NetworkCoordinating) -> NetworkPresenter in
            return NetworkPresenter(
                viewInput: viewInput,
                coordinator: coordinator
            )
        }
    }
    
    dynamic func networkCoordinator() {
        container.register(
            NetworkCoordinating.self
        ) { (resolver, navigationVC: UINavigationController) -> NetworkCoordinator in
            return NetworkCoordinator(resolver, presentationVC: navigationVC)
        }
    }
}
