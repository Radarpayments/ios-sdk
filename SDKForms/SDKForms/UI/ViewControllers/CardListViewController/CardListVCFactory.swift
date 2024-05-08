//
//  CardListVCFactory.swift
//  SDKForms
//
// 
//

import UIKit

final class CardListVCFactory: NSObject {
    
    private var tableView: UITableView?
    private var sections = [CardListVCSection]()
    private weak var owner: (FormsBaseViewController & CardListSelectable & CardListRemovable)?
    
    func setTableView(tableView: UITableView) {
        self.tableView = tableView
        
        setupTableView()
        registerCells()
    }
    
    func setOwner(_ owner: FormsBaseViewController & CardListSelectable & CardListRemovable) {
        self.owner = owner
    }
    
    func updateSections(sections: [CardListVCSection]) {
        self.sections = sections
        tableView?.reloadData()
    }
    
    private func setupTableView() {
        self.tableView?.separatorStyle = .none
    }
    
    private func registerCells() {
        tableView?.registerClass(BindingCardTableCell.self)
        tableView?.registerClass(AddNewCardTableCell.self)
        
        tableView?.registerReusableView(TableViewHeader.self)
    }
    
    private func cell(for indexPath: IndexPath) -> UITableViewCell? {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        
        switch itemModel {
        case let itemModel as BindingCardTableModel:
            let cell = tableView?.dequeueReusableCell(BindingCardTableCell.self, for: indexPath) as? BindingCardTableCell
            
            return cell?.bind(model: itemModel)

        case let itemModel as AddNewCardTableModel:
            let cell = tableView?.dequeueReusableCell(AddNewCardTableCell.self, for: indexPath) as? AddNewCardTableCell
            
            return cell?.bind(model: itemModel)
            
        default:
            return UITableViewCell()
        }
    }
}

extension CardListVCFactory: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if let cell = tableView.cellForRow(at: indexPath) {
            switch cell {
            case let cell as AddNewCardTableCell:
                owner?.onClickAddNewCard()
                
            case let cell as BindingCardTableCell:
                if let model = sections[indexPath.section].items[indexPath.row] as? BindingCardTableModel {
                    owner?.onClickCard(withId: model.id)
                }
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let targetSection = sections[section]
        
        switch targetSection.header {
        case let model as TableViewHeaderModel:
            let header = tableView.dequeReusableView(TableViewHeader.self) as? TableViewHeader
            return header?.bind(model: model)

        default: 
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        sections[indexPath.section].items[indexPath.row] is BindingCardTableModel
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if let _ = sections[indexPath.section].items[indexPath.row] as? BindingCardTableModel {
            return .delete
        }
        
        return .none
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete,
           let itemModel = sections[indexPath.section]
                           .items
                           .remove(at: indexPath.row) as? BindingCardTableModel {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            owner?.clickOnRemoveCell(itemModel.id)
        }
    }
}
