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

/// Перечисление сторон View.
enum ViewSide {
    
    /// Левый верхний край.
    case leftTop
    
    /// Центр слева.
    case leftCenter
    
    /// Левый нижний край.
    case leftBottom
    
    /// Правый верхний край.
    case rightTop
    
    /// Центр справа.
    case rightCenter
    
    /// Левый правый край.
    case rightBottom
    
    /// Точка, описывающая сторону.
    var point: CGPoint {
        switch self {
        case .leftTop:      return CGPoint(x: 0, y: 1)
        case .leftCenter:   return CGPoint(x: 0, y: 0.5)
        case .leftBottom:   return CGPoint(x: 0, y: 0)
        case .rightTop:     return CGPoint(x: 1, y: 1)
        case .rightCenter:  return CGPoint(x: 1, y: 0.5)
        case .rightBottom:  return CGPoint(x: 1, y: 0)
        }
    }
}
