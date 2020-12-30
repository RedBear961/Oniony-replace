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

/// Протокол переиспользуемого объекта.
protocol Reusable {
    
    /// Идентификатор переиспользования.
    static var reuseIdentifier: String { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}

extension UICollectionView {
    
    /// Перечисление типов дополнительных ячеек для большей типобезопасности.
    enum UICollectionViewElementKind: String, RawRepresentable {
        
        /// Шапка секции.
        case header
        
        /// Нижний колонтитул секции.
        case footer
        
        var rawValue: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionHeader
            }
        }
    }
    
    /// Регистрирует ячейку в коллекцию.
    func register<T: Reusable>(cell: T.Type) {
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    /// Регистрирует SupplementaryView в коллекцию.
    func register<T: Reusable>(
        cell: T.Type,
        forSupplementaryViewOfKind elementKind: UICollectionViewElementKind
    ) {
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        register(
            nib,
            forSupplementaryViewOfKind: elementKind.rawValue,
            withReuseIdentifier: cell.reuseIdentifier
        )
    }
    
    /// Получает ячейку по индексу пути.
    /// Удобное использование:
    ///
    ///     let cell = dequeueCell(for: indexPath) as SomeCell
    func dequeueCell<T: Reusable>(for indexPath: IndexPath, of type: T.Type = T.self) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath)
        guard let typedCell = cell as? T else {
            preconditionFailure("Не удалось получить ячейку с типом \(type)")
        }
        return typedCell
    }
    
    /// Получает SupplementaryView указанного типа по индексу пути.
    /// Удобное использование:
    ///
    ///     let cell = dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as SomeSupplementaryView
    func dequeueReusableSupplementaryView<T: Reusable>(
        ofKind elementKind: String,
        for indexPath: IndexPath,
        of type: T.Type = T.self
    ) -> T {
        let cell = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: type.reuseIdentifier, for: indexPath)
        guard let typedCell = cell as? T else {
            preconditionFailure("Не удалось получить SupplementaryView с типом \(type)")
        }
        return typedCell
    }
}

extension UITableView {
    
    /// Регистрирует ячейку в таблицу.
    func register<T: Reusable>(cell: T.Type) {
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    /// Получает ячейку по индексу пути.
    /// Удобное использование:
    ///
    ///     let cell = dequeueCell(for: indexPath) as SomeCell
    func dequeueCell<T: Reusable>(for indexPath: IndexPath, of type: T.Type = T.self) -> T {
        let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath)
        guard let typedCell = cell as? T else {
            preconditionFailure("Не удалось получить ячейку с типом \(type)")
        }
        return typedCell
    }
}
