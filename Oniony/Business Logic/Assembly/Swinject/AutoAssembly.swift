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

import Foundation
import Swinject

/// Автоматический сборщик.
///
/// Swinject отличается от Typhoon отсутствием рантайма.
/// Он не может самостоятельно получить селекторы всех регистраций и
/// сделать автоматический вызов.
/// Этот класс призван решить эту проблему.
@objcMembers
class AutoAssembly: NSObject, Assembly {
    
    /// Рабочий контейнер сборщика, передается Swinject'ом.
    private(set) var container: Container!
    
    /// Перебирает все селекторы и делает вызов.
    ///
    /// Метод должен быть помечен как `dynamic`, не принимать аргументов
    /// и не возвращать значение. Помечать класс или методы как `@objc`
    /// не требуется.
    func assemble(container: Container) {
        self.container = container
        
        // Получает список методов текущего класса.
        var count = UInt32()
        let pointer = class_copyMethodList(type(of: self), &count)
        let list = Array(UnsafeBufferPointer(start: pointer, count: Int(count)))
        
        // Для всех методов, которые соответствуют сигнатуре -[NSObject some].
        // Для Swift-разработчиков немного матчасти.
        // Любой метод Obj-C содержит минимум два аргумента:
        // Указатель на объект, которому посылается сообщение и вызываемый селектор.
        // Так что метод @objc func someFunc() с точки зрения Objc-C имеет вид
        // void someFunc(SomeObject *self, SEL _cmd) {}.
        // Больше инфы: https://habr.com/ru/post/270913/
        list.forEach { method in
            let selector = method_getName(method)
            guard selector != #selector(NSObject.init),
                  method_getNumberOfArguments(method) == 2,
                  String(cString: method_copyReturnType(method)) == "v" else {
                return
            }
            
            perform(selector)
        }
    }
}
