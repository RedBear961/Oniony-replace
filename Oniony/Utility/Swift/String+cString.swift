//
//  String+cString.swift
//  Quiz
//
//  Created by Георгий Черемных on 13.10.2020.
//  Copyright © 2020 Anatomy Karma. All rights reserved.
//

import Foundation

extension String {

    /// Возвращает C-строку с кодировкой utf-8.
    var cString: UnsafePointer<Int8> {
        guard let utf8String = (self as NSString).utf8String else {
            preconditionFailure("Не удалось получить С-строку из строки \(self)!")
        }
        return utf8String
    }
    
    /// Конструктор строки из C-строки.
    /// - Parameters:
    ///   - cString: Указатель на строку.
    ///   - encoding: Кодировка строки.
    init?(from cString: UnsafePointer<Int8>, encoding: String.Encoding) {
        guard let string = NSString(cString: cString, encoding: encoding.rawValue) else {
            return nil
        }
        self = string as String
    }
}
