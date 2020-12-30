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

/// Модель даных секции модуля настоойки сети.
struct NetworkSectionObject {
    
    /// Заголовок секции.
    let header: String?
    
    /// Нижний колонтитул секции.
    let footer: String?
    
    /// Модели ячеек.
    let cellObjects: [CellObject]
}

protocol NetworkViewInput: AnyObject {
    
    /// Обновляет отображение, используя модели данных секциий.
    func update(with sectionObjects: [NetworkSectionObject])
}

final class NetworkViewController: ViewController, NetworkViewInput {
    
    @IBOutlet private var tableView: UITableView!
    
    private var sectionObjects: [NetworkSectionObject] = []
    
    var viewOutput: NetworkViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Network.title
        
        tableView.register(cell: OnionyRightDetailCell.self)
        tableView.register(cell: OnionySubtitleCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewOutput.moduleWillAppear()
    }
    
    // MARK: - NetworkViewInput
    
    func update(with sectionObjects: [NetworkSectionObject]) {
        self.sectionObjects = sectionObjects
        tableView.reloadData()
    }
}

extension NetworkViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionObjects.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return sectionObjects[section].cellObjects.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = sectionObjects[indexPath.section]
        let cellObject = section.cellObjects[indexPath.row]
        
        if let cellObject = cellObject as? OnionyRightDetailCellObject {
            let cell = tableView.dequeueCell(for: indexPath) as OnionyRightDetailCell
            cell.update(with: cellObject)
            return cell
        } else if let cellObject = cellObject as? OnionySubtitleCellObject {
            let cell = tableView.dequeueCell(for: indexPath) as OnionySubtitleCell
            cell.update(with: cellObject)
            return cell
        }
        
        preconditionFailure("Неизвестный тип модели данных: \(cellObject.self).")
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return sectionObjects[section].header
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        return sectionObjects[section].footer
    }
}

extension NetworkViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        guard let header = view as? UITableViewHeaderFooterView,
              let label = header.textLabel else { return }
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Asset.headerText.color
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplayFooterView view: UIView,
        forSection section: Int
    ) {
        guard let header = view as? UITableViewHeaderFooterView,
              let label = header.textLabel else { return }
        label.textColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let cellObject = sectionObjects[indexPath.section].cellObjects[indexPath.row]
        viewOutput.didSelect(cellObject)
    }
}
