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

/// Протокол директора настроек приложения.
protocol PreferenceDirecting: AnyObject {
    
    /// Адрес домашней страницы.
    var homePage: URL { get set }
    
    /// Стиль открытия новых вкладок.
    var newTabStyle: NewTabStyle { get set }
}

private let kHomePageKey = "HomePage"
private let kNewTabStyleKey = "NewTabStyle"
private let kDefaultHomePage: URL = "https://duckduckgo.com"

/// Директор настроек приложения,.
final class PreferenceDirector: PreferenceDirecting {
    
    /// Адрес домашней страницы.
    @Stored(key: kHomePageKey, default: kDefaultHomePage)
    var homePage: URL
    
    /// Стиль открытия новой вкладки.
    @RawStored(key: kNewTabStyleKey, default: .home)
    var newTabStyle: NewTabStyle
}
