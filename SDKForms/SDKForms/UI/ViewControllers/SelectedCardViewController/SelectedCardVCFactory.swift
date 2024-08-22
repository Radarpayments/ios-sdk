//
//  SelectedCardVCFactory.swift
//  SDKForms
//
// 
//

import UIKit

final class SelectedCardVCFactory: NSObject {
    
    private var tableView: UITableView?
    private var sections = [SelectedCardVCSection]()
    private weak var owner: FormsBaseViewController?
    
    func setTableView(tableView: UITableView) {
        self.tableView = tableView
        
        setupTableView()
        registerCells()
    }
    
    func setOwner(_ owner: FormsBaseViewController) {
        self.owner = owner
    }
    
    func updateSections(sections: [SelectedCardVCSection]) {
        self.sections = sections
        tableView?.reloadData()
    }
    
    func updateTextFieldModel(model: TextFieldTableModel) {
        let sectionIndex = sections.firstIndex { section in
            section.items.contains { item in
                (item as? TextFieldTableModel) == model
            }
        }
        
        if let sectionIndex {
            let modelIndex = sections[sectionIndex].items
                .firstIndex(where: { ($0 as? TextFieldTableModel) == model })
            
            if let modelIndex {
                sections[sectionIndex].items[modelIndex] = model
            }
        }
    }
    
    func updateTwoTextFieldsModel(model: TwoTextFieldsTableModel) {
        let sectionIndex = sections.firstIndex { section in
            section.items.contains { item in
                (item as? TwoTextFieldsTableModel) == model
            }
        }
        
        if let sectionIndex {
            let modelIndex = sections[sectionIndex].items
                .firstIndex(where: { ($0 as? TwoTextFieldsTableModel) == model })
            
            if let modelIndex {
                sections[sectionIndex].items[modelIndex] = model
            }
        }
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = false
    }
    
    private func registerCells() {
        tableView?.registerClass(TextFieldTableCell.self)
        tableView?.registerClass(TwoTextFieldsTableCell.self)
        tableView?.registerClass(ButtonTableCell.self)
    }
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell? {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        
        switch itemModel {
        case let itemModel as TextFieldTableModel:
            let cell = TextFieldTableCell()
            return cell.bind(model: itemModel)
            
        case let itemModel as TwoTextFieldsTableModel:
            let cell = TwoTextFieldsTableCell()
            return cell.bind(model: itemModel)
            
        case let itemModel as ButtonTableModel:
            let cell = tableView?.dequeueReusableCell(ButtonTableCell.self, for: indexPath) as? ButtonTableCell
            
            return cell?.bind(
                model: itemModel,
                delegate: owner as? ButtonTableCellDelegate
            )
            
        default:
            return UITableViewCell()
        }
    }
}

extension SelectedCardVCFactory: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell(for: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
