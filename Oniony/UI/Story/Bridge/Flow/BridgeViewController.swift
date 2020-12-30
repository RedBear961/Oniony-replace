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

/// Модель даных секции модуля настоойки мостов.
struct BridgeSectionObject {
    
    /// Нижний колонтитул секции.
    let footer: String?
    
    /// Модели ячеек.
    let cellObjects: [CellObject]
}

protocol BridgeViewInput: AnyObject {
    
    /// Обновить отображение с помощью модели данных.
    func update(with sectionObjects: [BridgeSectionObject])
    
    /// Перезагрузить отображение, анимировав разницу.
    func reload(with sectionObjects: [BridgeSectionObject])
}

final class BridgeViewController: ViewController, BridgeViewInput {
    
    @IBOutlet private var tableView: UITableView!
    
    private var sectionObjects: [BridgeSectionObject] = []
    
    var viewOutput: BridgeViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Bridge.title
        
        tableView.register(cell: OnionySwitchCell.self)
        tableView.register(cell: OnionyCheckmarkCell.self)
        tableView.register(cell: OnionySubtitleCell.self)
        tableView.register(cell: OnionyRightDetailCell.self)
        
        viewOutput.moduleDidLoad()
    }
    
    // MARK: - BridgeViewInput
    
    func update(with sectionObjects: [BridgeSectionObject]) {
        self.sectionObjects = sectionObjects
        tableView.reloadData()
    }
    
    func reload(with sectionObjects: [BridgeSectionObject]) {
        self.sectionObjects = sectionObjects
        tableView.reloadSections(IndexSet(integersIn: 0...sectionObjects.count - 1), with: .automatic)
    }
}

extension BridgeViewController: UITableViewDataSource {
    
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
        
        switch cellObject {
        case let cellObject as OnionySwitchCellObject:
            let cell = tableView.dequeueCell(for: indexPath) as OnionySwitchCell
            cell.update(with: cellObject) { (_, isOn) in
                self.viewOutput.enableBridge(isOn)
            }
            return cell
        case let cellObject as OnionyCheckmarkCellObject:
            let cell = tableView.dequeueCell(for: indexPath) as OnionyCheckmarkCell
            cell.update(with: cellObject)
            return cell
        case let cellObject as OnionySubtitleCellObject:
            let cell = tableView.dequeueCell(for: indexPath) as OnionySubtitleCell
            cell.update(with: cellObject)
            return cell
        case let cellObject as OnionyRightDetailCellObject:
            let cell = tableView.dequeueCell(for: indexPath) as OnionyRightDetailCell
            cell.update(with: cellObject)
            return cell
        default:
            preconditionFailure("Неизвестный тип модели данных: \(cellObject.self).")
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        return sectionObjects[section].footer
    }
}

extension BridgeViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplayFooterView view: UIView,
        forSection section: Int
    ) {
        guard let header = view as? UITableViewHeaderFooterView,
              let label = header.textLabel else { return }
        label.textColor = Asset.secondaryText.color
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
