//
//  CardListViewController.swift
//  SDKForms
//
// 
//

import UIKit

protocol CardListSelectable {
    
    func onClickCard(withId id: String)
    func onClickAddNewCard()
    func onClickAllPayments()
}

protocol CardListRemovable {
    
    func clickOnRemoveCell(_ id: String)
}

public final class CardListViewController: FormsBaseViewController {
    
    private struct Constants {
        static let yourCards = "Your cards"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ThemeSetting.shared.colorTableBackground()
        
        return tableView
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemBold17
        label.text = .paymentMethod()
        label.textColor = ThemeSetting.shared.colorLabel()
        
        return label
    }()
    
    private let factory = CardListVCFactory()
    
    private let formatter = CardNumberFormatter()
    private let cardLogoResolver = AssetsResolver()
    
    private var mandatoryFieldsProvider: (any MandatoryFieldsProvider)?
    private var paymentConfig: PaymentConfig?
    
    convenience public init(
        paymentConfig: PaymentConfig?,
        mandatoryFieldsProvider: (any MandatoryFieldsProvider)?,
        callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    ) {
        self.init()

        self.mandatoryFieldsProvider = mandatoryFieldsProvider
        self.paymentConfig = paymentConfig
        self.callbackHandler = callbackHandler
    }
    
    override public func loadView() {
        super.loadView()
        
        factory.setTableView(tableView: tableView)
        factory.setOwner(self)
        setupSubviews()
        setupLayout()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        updateSections()
    }
    
    private func setupNavigationController() {
        navigationItem.titleView = navigationTitleLabel
        navigationController?.navigationBar.tintColor = ThemeSetting.shared.colorLabel()
        navigationController?.navigationItem.backButtonTitle = ""
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        
        if paymentConfig?.editingBindingsIsEnabled ?? false {
            navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Edit",
                style: .plain,
                target: self,
                action: #selector(clickOnEditButton)
            )
        }
    }
    
    @objc
    private func clickOnEditButton() {
        tableView.setEditing(true, animated: true)
        
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(clickOnSaveButton)
        )
    }
    
    @objc
    private func clickOnSaveButton() {
        tableView.setEditing(false, animated: true)
        
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(clickOnEditButton)
        )
    }
    
    private func updateSections() {
        var items: [AnyHashable] = cardsItemsModels()
        items.append(addNewCardModel())
        
        factory.updateSections(
            sections: [
                CardListVCSection(
                    type: .cards,
                    header: cardsSectionHeader(),
                    items: items
                )
            ]
        )
    }
    
    private func cardsSectionHeader() -> TableViewHeaderModel {
        TableViewHeaderModel(
            id: Constants.yourCards,
            title: Constants.yourCards
        )
    }
    
    private func cardsItemsModels() -> [AnyHashable] {
        guard let cards = paymentConfig?.cards else { return [] }

        let items = cards
            .filter { card in
                !(paymentConfig?.cardsToDelete.contains { card.bindingId != $0.bindingId } ?? false)
            }
            .compactMap {
            let cardLogoName = cardLogoResolver.resolveByPan(pan: $0.pan)

            return BindingCardTableModel(
                id: $0.bindingId,
                cardSystemImageName: cardLogoName,
                cardNumberText: formatter.maskCardNumber(pan: $0.pan),
                cardExpiryText: $0.expiryDate?.formatExpiryDate() ?? ""
            )
        }
        
        return items
    }
    
    private func addNewCardModel() -> AddNewCardTableModel {
        let leftImageName = cardLogoResolver
            .resolveAddCard(theme: ThemeSetting.shared.getTheme())
        
        return AddNewCardTableModel(
            leftImageName: leftImageName,
            title: .addCard()
        )
    }
}

extension CardListViewController {
    
    private func setupSubviews() {
        view.addSubview(tableView)
        
        tableView.delegate = factory
        tableView.dataSource = factory
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}


extension CardListViewController: CardListSelectable {
    
    func onClickCard(withId id: String) {
        guard let card = paymentConfig?.cards
            .first(where: { $0.bindingId == id })
        else { return }
        
        actionWasCalled = true
        let bindingCardVC = SelectedCardViewController(
            paymentConfig: paymentConfig,
            card: card,
            mandatoryFieldsProvider: self.mandatoryFieldsProvider,
            callbackHandler: callbackHandler
        )

        navigationController?.pushViewController(bindingCardVC, animated: true)
    }
    
    func onClickAddNewCard() {
        actionWasCalled = true
        let newCardVC = NewCardViewController(
            paymentConfig: paymentConfig,
            mandatoryFieldsProvider: self.mandatoryFieldsProvider,
            callbackHandler: callbackHandler
        )
        
        navigationController?.pushViewController(newCardVC, animated: true)
    }
    
    func onClickAllPayments() {}
}

extension CardListViewController: CardListRemovable {
    
    func clickOnRemoveCell(_ id: String) {
        guard let card = paymentConfig?.cards
            .first(where: { $0.bindingId == id })
        else { return }

        paymentConfig?.cardsToDelete.insert(card)
    }
}
