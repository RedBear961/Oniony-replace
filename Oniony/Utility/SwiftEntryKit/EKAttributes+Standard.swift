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

import SwiftEntryKit

extension EKAttributes {
    
    static var standard: EKAttributes {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        attributes.exitAnimation = .none
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        )
        attributes.screenBackground = .color(
            color: EKColor.black.with(alpha: 0.7)
        )
        
        let width = PositionConstraints.Edge.ratio(value: 0.9)
        let height = PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(
            width: width, height: height
        )
        
        let value = EKAttributes.Shadow.Value(
            color: EKColor.black.with(alpha: 0.25),
            opacity: 1,
            radius: 8,
            offset: .zero
        )
        attributes.shadow = .active(with: value)
        
        return attributes
    }
}
