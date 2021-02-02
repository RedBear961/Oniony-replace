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

final class BridgeAssembly: AutoAssembly {
    
    dynamic func bridgeViewController() {
        container.register(
            BridgeViewController.self
        ) { (resolver, coordinator: BridgeCoordinating) -> BridgeViewController in
            let controller = StoryboardScene.Bridge.bridgeViewController.instantiate()
            controller.viewOutput = resolver.resolve(
                BridgeViewOutput.self,
                arguments: controller as BridgeViewInput, coordinator
            )!
            return controller
        }
    }
    
    dynamic func bridgePresenter() {
        container.register(
            BridgeViewOutput.self
        ) { (resolver, viewInput: BridgeViewInput, coordinator: BridgeCoordinating) -> BridgePresenter in
            return BridgePresenter(
                viewInput: viewInput,
                coordinator: coordinator,
                factory: resolver.resolve(BridgeCellFactory.self)!,
                bridgeStorage: resolver.resolve(BridgeStorage.self)!
            )
        }
    }
    
    dynamic func bridgeCoordinator() {
        container.register(
            BridgeCoordinating.self
        ) { (resolver, navigationVC: UINavigationController) -> BridgeCoordinator in
            return BridgeCoordinator(resolver, presentationVC: navigationVC)
        }
    }
    
    dynamic func bridgeCellFactory() {
        container.register(
            BridgeCellFactory.self
        ) { (resolver) -> BridgeCellFactoryImpl in
            return BridgeCellFactoryImpl(
                bridgeStorage: resolver.resolve(BridgeStorage.self)!
            )
        }
    }
}
