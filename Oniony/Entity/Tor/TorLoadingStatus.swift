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

// Все возможные статусы с описанием.
private let tags: [String: String] = [
    "con": L10n.TorLoading.Tag.con,
    "conn_done": L10n.TorLoading.Tag.connDone,
    "handshake": L10n.TorLoading.Tag.handshake,
    "onehop_create": L10n.TorLoading.Tag.onehopCreate,
    "requesting_status": L10n.TorLoading.Tag.requestingStatus,
    "loading_status": L10n.TorLoading.Tag.loadingStatus,
    "loading_keys": L10n.TorLoading.Tag.loadingKeys,
    "requesting_descriptors": L10n.TorLoading.Tag.requestingDescriptors,
    "loading_descriptors": L10n.TorLoading.Tag.loadingDescriptors,
    "enough_dirinfo": L10n.TorLoading.Tag.enoughDirinfo,
    "ap_conn": L10n.TorLoading.Tag.apConn,
    "ap_conn_done": L10n.TorLoading.Tag.apConnDone,
    "handshake_done": L10n.TorLoading.Tag.handshakeDone,
    "ap_handshake": L10n.TorLoading.Tag.apHandshake,
    "ap_handshake_done": L10n.TorLoading.Tag.apHandshakeDone,
    "circuit_create": L10n.TorLoading.Tag.circuitCreate,
    "done": L10n.TorLoading.Tag.done
]

/// Статус загрузки тор-сети.
struct TorLoadingStatus {
    
    /// Прогресс загрузки [0; 100].
    let progress: Int
    
    /// Описание текущего состояния.
    let summary: String
    
    /// Строка журнала отладки.
    let log: String
    
    /// Конструктор статуса из аргументов, присланных тор-сетью.
    init?(_ arguments: [String: String]) {
        guard let progress = arguments["PROGRESS"],
              let tag = arguments["TAG"],
              let summary = tags[tag] else {
            return nil
        }
        
        self.progress = Int(progress)!
        self.summary = summary
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        self.log = """
            \(timestamp) [notice] Bootstrapped \(self.progress)% (\(tag)): \(summary)
        """
    }
}
