//
//  Reusable.swift
//  SwitipsUS
//
//  Created by Георгий Черемных on 19.10.2020.
//  Copyright © 2020 Besttoolbars. All rights reserved.
//

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
