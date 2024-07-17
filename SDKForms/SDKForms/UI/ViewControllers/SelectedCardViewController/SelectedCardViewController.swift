//
//  SelectedCardViewController.swift
//  SDKForms
//
// 
//

import UIKit
import SDKCore

public final class SelectedCardViewController: FormsBaseViewController {
    
    private struct Constants {
        static let cardNumber = "cardNumber"
        static let expiryCVCData = "expiryCVCData"
        static let cardHolder = "cardHolder"
        static let submitModel = "submitModel"
    }
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ThemeSetting.shared.colorTableBackground()
        
        return tableView
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemBold17
        label.text = .payment()
        label.textColor = ThemeSetting.shared.colorLabel()
        
        return label
    }()
    
    private lazy var footerView: VerifyCompaniesReusableView = {
        let view = VerifyCompaniesReusableView()
        return view
    }()
    
    private let factory = SelectedCardVCFactory()
    
    private let cardCodeValidator = CardCodeValidator()
    private let cardHolderValidator = CardHolderValidator()

    private let cryptogramProcessor = try? SdkForms.shared.cryptogramProcessor()

    private var cardCVCValidation = ValidationResult.VALID
    private var cardHolderValidation = ValidationResult.VALID

    private var paymentConfig: PaymentConfig?
    private var card: Card?
    
    private var cardCVCEntered = ""
    private var cardHolderEntered = ""
    
    convenience public init(
        paymentConfig: PaymentConfig?,
        card: Card?,
        callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    ) {
        self.init()

        self.paymentConfig = paymentConfig
        self.card = card
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
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nextInputView()?.setActive(true)
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
    }
    
    private func checkFormValidation() -> Bool {
        if paymentConfig?.holderInputOptions == .visible {
            cardHolderValidation = cardHolderValidator.validate(data: cardHolderEntered)
        }

        if paymentConfig?.storedPaymentMethodCVCRequired ?? true {
            cardCVCValidation = cardCodeValidator.validate(data: cardCVCEntered)
        }
        
        return cardCVCValidation.isValid && cardHolderValidation.isValid
    }
    
    private func preparePaymentData() {
        guard let card,
              let config = paymentConfig
        else { return }
        
        actionWasCalled = true

        do {
            let paymentToken = try cryptogramProcessor?.create(
                order: config.order,
                timestamp: config.timestamp,
                uuid: config.uuid,
                cardInfo: CoreCardInfo(
                    identifier: .storedPaymentMethodIdentifier(card.bindingId),
                    cvv: cardCVCEntered
                ),
                registeredFrom: config.registeredFrom
            )
            
            let cryptogramData = CryptogramData(
                status: PaymentDataStatus.succeeded,
                paymentToken: paymentToken ?? "",
                info: PaymentInfoBindCard(
                    order: config.order,
                    bindingId: card.bindingId
                ),
                deletedCardList: config.cardsToDelete
            )
            callbackHandler?.onSuccess(result: cryptogramData)
        } catch let error as SDKException {
            callbackHandler?.onFail(error: error)
        } catch {
            callbackHandler?.onFail(error: SDKException())
        }
    }
    
    private func updateSections() {
        guard let card else { return }
        
        var items = [AnyHashable]()
        
        items.append(cardNumberFieldModel(card: card))
        items.append(cardExpiryCvcFieldsModel(card: card))
        
        if paymentConfig?.holderInputOptions == .visible {
            items.append(cardHolderFieldModel())
        }
        
        items.append(actionButtonModel())
        
        factory.updateSections(
            sections: [
                SelectedCardVCSection(
                    type: .cardInfo,
                    items: items
                )
            ]
        )
    }
    
    private func cardNumberFieldModel(card: Card) -> TextFieldTableModel {
        TextFieldTableModel(
            id: Constants.cardNumber,
            textFieldViewConfig: CardDataTextFieldViewState(
                placeholder: .cardNumber(),
                text: card.pan,
                pattern: .cardNumber,
                hideleftImageView: false,
                isSecureInput: true,
                inputIsAvailable: false, 
                textFieldViewTextDidChange: nil
            )
        )
    }
    private func cardExpiryCvcFieldsModel(card: Card) -> TwoTextFieldsTableModel {
        TwoTextFieldsTableModel(
            id: Constants.expiryCVCData,
            cardExpiryViewConfig: CardDataTextFieldViewState(
                placeholder: .mmYY(),
                text: card.expiryDate?.formatExpiryDate() ?? "",
                pattern: .cardExpiry,
                isSecureInput: true,
                inputIsAvailable: false, 
                textFieldViewTextDidChange: nil
            ),
            cardCVCViewConfig: CardDataTextFieldViewState(
                placeholder: .cvcTitle(),
                text: !(paymentConfig?.storedPaymentMethodCVCRequired ?? false) ? "   " : cardCVCEntered,
                pattern: .cardCVC,
                errorMessage: cardCVCValidation.errorMessage ?? "",
                isSecureInput: true,
                inputIsAvailable: (paymentConfig?.storedPaymentMethodCVCRequired ?? false),
                textFieldViewTextDidChange: cardCVCTextDidChange
            )
        )
    }
    
    private func actionButtonModel() -> ButtonTableModel {
        ButtonTableModel(
            id: Constants.submitModel,
            title: paymentConfig?.buttonText ?? .doneButtonTitle()
        )
    }
    
    private func cardHolderFieldModel() -> CardHolderTableModel {
        CardHolderTableModel(
            id: Constants.cardHolder,
            textFieldViewConfig: CardDataTextFieldViewState(
                placeholder: .cardholderPlaceholder(),
                pattern: .cardHolder,
                errorMessage: cardHolderValidation.errorMessage ?? "", 
                textFieldViewTextDidChange: cardHolderTextDidChange
            )
        )
    }
}

extension SelectedCardViewController {
    
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.addSubview(footerView)
        
        tableView.delegate = factory
        tableView.dataSource = factory
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        tableView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
}

extension SelectedCardViewController: ButtonTableCellDelegate {
    
    func clickOnActionButton() {
        let isValid = self.checkFormValidation()
        
        updateSections()
        
        if isValid {
            preparePaymentData()
        }
    }
}

// MARK: - Inputs text changing handlers
extension SelectedCardViewController {
    
    private func cardCVCTextDidChange(_ inputView: InputView) {
        cardCVCEntered = inputView.value
        cardCVCValidation = checkValidation(value: cardCVCEntered, validator: cardCodeValidator)
        setActiveNextInputIfValid(cardCVCValidation, activeInput: inputView)
    }
    
    private func cardHolderTextDidChange(_ inputView: InputView) {
        cardHolderEntered = inputView.value
        cardHolderValidation = checkValidation(value: cardHolderEntered, validator: cardHolderValidator)
    }
}

extension SelectedCardViewController: InputTableVC {}
