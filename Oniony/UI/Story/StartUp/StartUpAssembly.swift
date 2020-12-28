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

final class StartUpAssembly: AutoAssembly {
    
    dynamic func startUpViewController() {
        container.register(
            StartUpViewController.self
        ) { (resolver, coordinator: StartUpCoordinating) -> StartUpViewController in
            let controller = StoryboardScene.StartUp.startUpViewController.instantiate()
            controller.viewOutput = resolver.resolve(
                StartUpViewOutput.self,
                arguments: controller as StartUpViewInput, coordinator
            )!
            return controller
        }
    }
    
    dynamic func startUpPresenter() {
        container.register(
            StartUpViewOutput.self
        ) { (_, viewInput: StartUpViewInput, coordinator: StartUpCoordinating) -> StartUpPresenter in
            return StartUpPresenter(viewInput: viewInput, coordinator: coordinator)
        }
    }
    
    dynamic func startUpCoordinator() {
        container.register(
            StartUpCoordinating.self
        ) { (resolver, navigationVC: UINavigationController) -> StartUpCoordinator in
            return StartUpCoordinator(resolver, presentationVC: navigationVC)
        }
    }
}
