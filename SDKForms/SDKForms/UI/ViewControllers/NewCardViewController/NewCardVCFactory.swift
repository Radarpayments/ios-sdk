//
//  NewCardVCFactory.swift
//  SDKForms
//
// 
//

import UIKit

final class NewCardVCFactory: NSObject {
    
    private var tableView: UITableView?
    private var sections = [NewCardVCSection]()
    private weak var owner: FormsBaseViewController?
    
    func setTableView(tableView: UITableView) {
        self.tableView = tableView
        
        setupTableView()
        registerCells()
    }
    
    func setOwner(_ owner: FormsBaseViewController) {
        self.owner = owner
    }
    
    func updateSections(sections: [NewCardVCSection]) {
        self.sections = sections
        tableView?.reloadData()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = false
    }
    
    private func registerCells() {
        tableView?.registerClass(BankLogoTableCell.self)
        tableView?.registerClass(TextFieldTableCell.self)
        tableView?.registerClass(TwoTextFieldsTableCell.self)
        tableView?.registerClass(CardHolderTableCell.self)
        tableView?.registerClass(SwitchTableCell.self)
        tableView?.registerClass(ButtonTableCell.self)
    }
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell? {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        
        switch itemModel {
        case let itemModel as BankLogoTableModel:
            let cell = tableView?.dequeueReusableCell(BankLogoTableCell.self, for: indexPath) as? BankLogoTableCell
            return cell?.bind(model: itemModel)
            
        case let itemModel as TextFieldTableModel:
            let cell = tableView?.dequeueReusableCell(TextFieldTableCell.self, for: indexPath) as? TextFieldTableCell
            return cell?.bind(
                model: itemModel
            )
            
        case let itemModel as TwoTextFieldsTableModel:
            let cell = tableView?.dequeueReusableCell(TwoTextFieldsTableCell.self, for: indexPath) as? TwoTextFieldsTableCell
            return cell?.bind(
                model: itemModel
            )
            
        case let itemModel as CardHolderTableModel:
            let cell = tableView?.dequeueReusableCell(CardHolderTableCell.self, for: indexPath) as? CardHolderTableCell
            return cell?.bind(
                model: itemModel
            )
            
        case let itemModel as SwitchTableModel:
            let cell = tableView?.dequeueReusableCell(SwitchTableCell.self, for: indexPath) as? SwitchTableCell
            return cell?.bind(
                model: itemModel,
                delegate: owner as? SwitchTableCellDelegate
            )
            
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

extension NewCardVCFactory: UITableViewDelegate, UITableViewDataSource {
    
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
