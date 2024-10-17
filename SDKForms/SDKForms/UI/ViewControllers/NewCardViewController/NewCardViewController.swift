//
//  NewCardViewController.swift
//  SDKForms
//
// 
//

import UIKit
import SDKCore

public final class NewCardViewController: FormsBaseViewController {
    
    private struct Constants {
        static let bankLogo = "bankLogo"
        static let cardNumber = "cardNumber"
        static let expiryCVCData = "expiryCVCData"
        static let cardHolder = "cardHolder"
        static let switchTableModel = "switchTableModel"
        static let submitModel = "submitModel"
    }

    private lazy var tableView: UITableView = {
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
    
    private let factory = NewCardVCFactory()
    
    private let cardNumberValidator = CardNumberValidator()
    private let cardExpiryValidator = CardExpiryValidator()
    private let cardCodeValidator = CardCodeValidator()
    private let cardHolderValidator = CardHolderValidator()
    
    private let cryptogramProcessor = try? SdkForms.shared.cryptogramProcessor()
    
    private var cardNumberEntered = ""
    private var cardExpiryEntered = ""
    private var cardCVCEntered = ""
    private var cardHolderEntered = ""
    private var saveSwitchIsOn = false
    
    private var cardNumberValidation = ValidationResult.VALID
    private var cardExpiryValidation = ValidationResult.VALID
    private var cardCVCValidation = ValidationResult.VALID
    private var cardHolderValidation = ValidationResult.VALID
    
    private var paymentConfig: PaymentConfig?
    
    convenience public init(
        paymentConfig: PaymentConfig?,
        callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    ) {
        self.init()
        
        self.paymentConfig = paymentConfig
        self.callbackHandler = callbackHandler
        self.saveSwitchIsOn = paymentConfig?.cardSaveOptions == .yesByDefault
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
    }
    
    private func checkFormValidation() -> Bool {
        cardNumberValidation = cardNumberValidator.validate(data: cardNumberEntered.digitsOnly())
        cardExpiryValidation = cardExpiryValidator.validate(data: cardExpiryEntered)
        cardCVCValidation = cardCodeValidator.validate(data: cardCVCEntered)
        
        if paymentConfig?.holderInputOptions == .visible {
            cardHolderValidation = cardHolderValidator.validate(data: cardHolderEntered)
        }
        
        return cardNumberValidation.isValid
            && cardExpiryValidation.isValid
            && cardCVCValidation.isValid
            && cardHolderValidation.isValid
    }
    
    private func preparePaymentData() {
        guard let config = paymentConfig else { return }

        actionWasCalled = true
        do {
            let seToken = try cryptogramProcessor?.create(
                order: config.order,
                timestamp: config.timestamp,
                uuid: config.uuid,
                cardInfo: CoreCardInfo(
                    identifier: .cardPanIdentifier(cardNumberEntered.digitsOnly()),
                    expDate: cardExpiryEntered.toExpDate(),
                    cvv: cardCVCEntered
                ),
                registeredFrom: config.registeredFrom
            )
            
            let cryptogramData = CryptogramData(
                status: PaymentDataStatus.succeeded,
                seToken: seToken ?? "",
                info: PaymentInfoNewCard(
                    order: config.order,
                    saveCard: saveSwitchIsOn,
                    holder: cardHolderEntered
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
        var sections = [NewCardVCSection]()

        sections.append(
            NewCardVCSection(
                type: .logo,
                items: [ BankLogoTableModel(id: Constants.bankLogo) ]
            )
        )
        
        var cardInfoSection = NewCardVCSection(type: .cardInfo, items: [])
        cardInfoSection.items.append(cardNumberFieldModel())
        cardInfoSection.items.append(cardExpiryCvcFieldsModel())
        
        if paymentConfig?.holderInputOptions == .visible {
            cardInfoSection.items.append(cardHolderFieldModel())
        }
        
        if paymentConfig?.cardSaveOptions != .hide {
            cardInfoSection.items.append(saveSwitchModel())
        }
        
        cardInfoSection.items.append(actionButtonModel())
        sections.append(cardInfoSection)
        
        factory.updateSections(sections: sections)
    }
    
    private func cardNumberFieldModel() -> TextFieldTableModel {
        TextFieldTableModel(
            id: Constants.cardNumber,
            textFieldViewConfig: CardDataTextFieldViewState(
                placeholder: .cardNumberTitle(),
                pattern: .cardNumber,
                errorMessage: cardNumberValidation.errorMessage ?? "",
                hideleftImageView: false
            )
        )
    }
    
    private func cardExpiryCvcFieldsModel() -> TwoTextFieldsTableModel {
        TwoTextFieldsTableModel(
            id: Constants.expiryCVCData,
            cardExpiryViewConfig: CardDataTextFieldViewState(
                placeholder: .mmYY(),
                pattern: .cardExpiry,
                errorMessage: cardExpiryValidation.errorMessage ?? ""
            ),
            cardCVCViewConfig: CardDataTextFieldViewState(
                placeholder: .cvcTitle(),
                pattern: .cardCVC,
                errorMessage: cardCVCValidation.errorMessage ?? "",
                isSecureInput: true
            )
        )
    }
    
    private func cardHolderFieldModel() -> CardHolderTableModel {
        CardHolderTableModel(
            id: Constants.cardHolder,
            textFieldViewConfig: CardDataTextFieldViewState(
                placeholder: .cardholderPlaceholder(),
                pattern: .cardHolder,
                errorMessage: cardHolderValidation.errorMessage ?? ""
            )
        )
    }

    private func saveSwitchModel() -> SwitchTableModel {
        SwitchTableModel(
            id: Constants.switchTableModel,
            title: .switchViewTitle(),
            isOn: saveSwitchIsOn
        )
    }
    
    private func actionButtonModel() -> ButtonTableModel {
        ButtonTableModel(
            id: Constants.submitModel,
            title: paymentConfig?.buttonText ?? .doneButtonTitle()
        )
    }
}

extension NewCardViewController {
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        tableView.delegate = factory
        tableView.dataSource = factory
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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

extension NewCardViewController: SwitchTableCellDelegate {
    
    func switchDidChange(_ isOn: Bool) {
        saveSwitchIsOn = isOn
    }
}

extension NewCardViewController: ButtonTableCellDelegate {
    
    func clickOnActionButton() {
        let isValid = self.checkFormValidation()
        
        updateSections()
        
        if isValid {
            preparePaymentData()
        }
    }
}

extension NewCardViewController: TextFieldTableCellDelegate {
    
    func textDidChange(id: String, _ text: String) {
        switch id {
        case Constants.cardNumber: cardNumberEntered = text
        case Constants.cardHolder: cardHolderEntered = text
        default: break
        }
    }
}

extension NewCardViewController: TwoTextFieldsTableCellDelegate {
    
    func cardExpiryTextDidChange(_ text: String) {
        cardExpiryEntered = text
    }
    
    func cardCVCTextDidChange(_ text: String) {
        cardCVCEntered = text
    }
}
