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

/// Псевдоним для перечислений, чтобы уточнить,
/// что это сделано именно для хранения.
typealias RawStoragable = RawRepresentable

/// Обертка над свойством, позволяющая хранить значение в
/// `UserDefaults`.
/// ```
/// class SomeClass {
///
///     @Stored(key: "SomeKey", default: false)
///     var someProperty: Bool
/// }
/// ```
/// Установка этого свойсва приведет к установке значения в `UserDefaults`.
/// Равно как и получение этого свойство, вызовет обращение к хранилищу.
@propertyWrapper
class Stored<T> {
    
    /// Ключ по-которому хранится свойство.
    let key: String
    
    /// Значение по-умолчанию для этого свойство.
    /// Будет использовано, если хранилище не содержит значение
    /// по-этому ключу.
    let defaultValue: T
    
    fileprivate let storage: UserDefaults
    
    init(key: String, default value: T) {
        self.key = key
        self.defaultValue = value
        self.storage = UserDefaults.standard
    }
    
    var wrappedValue: T {
        get {
            let object = storage.object(forKey: key) as? T
            return object ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

/// Расширение `Stored` на поле опционалов.
@propertyWrapper
class OptionalStored<T>: Stored<T?> {
    
    override init(key: String, default value: T? = nil) {
        super.init(key: key, default: value)
    }
    
    override var wrappedValue: T? {
        get { super.wrappedValue }
        set { super.wrappedValue = newValue }
    }
}

/// Расширение `Stored` на поле перечислений.
/// Перечисление должно соответствовать типу `RawStoragable` aka `RawRepresentable`.
@propertyWrapper
final class RawStored<T: RawStoragable>: Stored<T> {
    
    override var wrappedValue: T {
        get {
            guard let rawValue = storage.object(forKey: key) as? T.RawValue else {
                return defaultValue
            }
            
            return T(rawValue: rawValue) ?? defaultValue
        }
        set {
            storage.set(newValue.rawValue, forKey: key)
        }
    }
}

/// Расширение `OptionalStored` на поле перечислений.
/// Перечисление должно соответствовать типу `RawStoragable` aka `RawRepresentable`.
@propertyWrapper
final class OptionalRawStored<T: RawStoragable>: OptionalStored<T> {

    override var wrappedValue: T? {
        get {
            guard let rawValue = storage.object(forKey: key) as? T.RawValue else {
                return defaultValue
            }
            
            return T(rawValue: rawValue) ?? defaultValue
        }
        set {
            storage.set(newValue?.rawValue, forKey: key)
        }
    }
}
