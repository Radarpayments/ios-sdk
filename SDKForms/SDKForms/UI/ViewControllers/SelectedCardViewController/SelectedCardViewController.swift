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
        static let expiryData = "expiryData"
        static let cvcData = "cvcData"
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

    private var cardCVCValidation = ValidationResult.VALID
    private var cardHolderValidation = ValidationResult.VALID

    private var paymentConfig: PaymentConfig?
    private var card: Card?
    
    private var cardCVCEntered = ""
    private var cardHolderEntered = ""
    
    private var mandatoryFieldsValues = [String: String]()
    private var mandatoryFieldsValidations = [String: ValidationResult]()
    
    private var mandatoryFieldsProvider: (any MandatoryFieldsProvider)?
    
    convenience public init(
        paymentConfig: PaymentConfig?,
        card: Card?,
        mandatoryFieldsProvider: (any MandatoryFieldsProvider)?,
        callbackHandler: (any ResultCryptogramCallback<CryptogramData>)?
    ) {
        self.init()

        self.paymentConfig = paymentConfig
        self.card = card
        self.mandatoryFieldsProvider = mandatoryFieldsProvider
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
    
    override func handleKeyboardChanging(keyboardFrame: CGRect) {
        tableView.setBottomInset(keyboardFrame.height)
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
        
        mandatoryFieldsValidations = mandatoryFieldsProvider?.validateFieldsValues(fieldValues: mandatoryFieldsValues) ?? [:]
        let mandatoryFieldsAllValid = !mandatoryFieldsValidations.values.contains(where: { !$0.isValid })
        
        return cardCVCValidation.isValid
            && cardHolderValidation.isValid
            && mandatoryFieldsAllValid
    }
    
    private func preparePaymentData() {
        guard let card,
              let config = paymentConfig
        else { return }
        
        actionWasCalled = true

        do {
            let cryptogramData = CryptogramData(
                status: PaymentDataStatus.succeeded,
                info: PaymentInfoBindCard(
                    order: config.order,
                    bindingId: card.bindingId,
                    cvc: cardCVCEntered,
                    mandatoryFieldsValues: mandatoryFieldsValues
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
        
        var sections = [SelectedCardVCSection]()
        
        var cardInfoSection = SelectedCardVCSection(type: .cardInfo, items: [])
        cardInfoSection.items.append(cardNumberFieldModel(card: card))
        cardInfoSection.items.append(cardExpiryCvcFieldsModel(card: card))
        
        if paymentConfig?.holderInputOptions == .visible {
            cardInfoSection.items.append(cardHolderFieldModel())
        }
        sections.append(cardInfoSection)
        
        var mandatoryFieldsItems = mandatoryFieldsModels()
        if !mandatoryFieldsItems.isEmpty {
            var mandatoryFieldsSection = SelectedCardVCSection(type: .mandatoryFields, items: [])
            mandatoryFieldsSection.items = mandatoryFieldsItems
            sections.append(mandatoryFieldsSection)
        }

        var actionsSection = SelectedCardVCSection(type: .actions, items: [])
        actionsSection.items.append(actionButtonModel())
        sections.append(actionsSection)
        
        factory.updateSections(sections: sections)
    }
    
    private func cardNumberFieldModel(card: Card) -> TextFieldTableModel {
        TextFieldTableModel(
            id: Constants.cardNumber,
            textFieldViewConfig: CardDataTextFieldViewState(
                id: Constants.cardNumber,
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
            leadingTextFieldViewConfig: CardDataTextFieldViewState(
                id: Constants.expiryData,
                placeholder: .mmYY(),
                text: card.expiryDate?.formatExpiryDate() ?? "",
                pattern: .cardExpiry,
                isSecureInput: true,
                inputIsAvailable: false, 
                textFieldViewTextDidChange: nil
            ),
            trailingTextFieldViewConfig: CardDataTextFieldViewState(
                id: Constants.cvcData,
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
    
    private func cardHolderFieldModel() -> TextFieldTableModel {
        TextFieldTableModel(
            id: Constants.cardHolder,
            textFieldViewConfig: CardDataTextFieldViewState(
                id: Constants.cardHolder,
                placeholder: .cardholderPlaceholder(),
                text: cardHolderEntered,
                pattern: .cardHolder,
                errorMessage: cardHolderValidation.errorMessage ?? "", 
                textFieldViewTextDidChange: cardHolderTextDidChange
            )
        )
    }
    
    private func mandatoryFieldsModels() -> [AnyHashable] {
        var tableModels = [AnyHashable]()
        
        guard let card else { return tableModels }
        
        mandatoryFieldsProvider?.resolveFields(forPaymentSystem: card.paymentSystem)
            .forEach { mandatoryItem in
                switch mandatoryItem {
                case let .singleField(field):
                    if mandatoryFieldsValues[field.id] == nil {
                        mandatoryFieldsValues[field.id] = field.preFilledValue
                    }
                    
                    tableModels.append(
                        TextFieldTableModel(
                            id: field.id,
                            textFieldViewConfig: CardDataTextFieldViewState(
                                id: field.id,
                                placeholder: field.placeholder,
                                text: mandatoryFieldsValues[field.id] ?? "",
                                pattern: mandatoryFieldsProvider?.textPattern(forFieldId: field.id) ?? .plain,
                                errorMessage: mandatoryFieldsValidations[field.id]?.errorMessage ?? "",
                                textFieldViewTextDidChange: mandatoryFieldTextDidChange,
                                textFieldDoneButtonHandler: doneButtonHandler
                            )
                        )
                    )
                case let .twoFields(fields):
                    var leadingConfig: CardDataTextFieldViewState?
                    var trailingConfig: CardDataTextFieldViewState?
                    
                    if let leadingField = fields.leadingField {
                        if mandatoryFieldsValues[leadingField.id] == nil {
                            mandatoryFieldsValues[leadingField.id] = leadingField.preFilledValue
                        }
                        
                        leadingConfig = CardDataTextFieldViewState(
                            id: leadingField.id,
                            placeholder: leadingField.placeholder,
                            text: mandatoryFieldsValues[leadingField.id] ?? "",
                            pattern: mandatoryFieldsProvider?.textPattern(forFieldId: leadingField.id) ?? .plain,
                            errorMessage: mandatoryFieldsValidations[leadingField.id]?.errorMessage ?? "",
                            textFieldViewTextDidChange: mandatoryFieldTextDidChange,
                            textFieldDoneButtonHandler: doneButtonHandler
                        )
                    }
                    
                    if let trailingField = fields.trailingField {
                        if mandatoryFieldsValues[trailingField.id] == nil {
                            mandatoryFieldsValues[trailingField.id] = trailingField.preFilledValue
                        }
                        
                        trailingConfig = CardDataTextFieldViewState(
                            id: trailingField.id,
                            placeholder: trailingField.placeholder,
                            text: mandatoryFieldsValues[trailingField.id] ?? "",
                            pattern: mandatoryFieldsProvider?.textPattern(forFieldId: trailingField.id) ?? .plain,
                            errorMessage: mandatoryFieldsValidations[trailingField.id]?.errorMessage ?? "",
                            textFieldViewTextDidChange: mandatoryFieldTextDidChange,
                            textFieldDoneButtonHandler: doneButtonHandler
                        )
                    }
                    tableModels.append(
                        TwoTextFieldsTableModel(
                            id: (leadingConfig?.id ?? "") + (trailingConfig?.id ?? ""),
                            leadingTextFieldViewConfig: leadingConfig,
                            trailingTextFieldViewConfig: trailingConfig
                        )
                    )
                }
            }
        
        return tableModels
    }
}

extension SelectedCardViewController {
    
    private func setupSubviews() {
        view.backgroundColor = .systemColorTableBackgroundColor
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        tableView.delegate = factory
        tableView.dataSource = factory
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        tableView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate(
            [
                footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
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
        cardCVCValidation = .VALID 
        let cardCVCValidation = checkValidation(value: cardCVCEntered, validator: cardCodeValidator)
        setActiveNextInputIfValid(cardCVCValidation, activeInput: inputView)
        if let card {
            factory.updateTwoTextFieldsModel(model: cardExpiryCvcFieldsModel(card: card))
        }
    }
    
    private func cardHolderTextDidChange(_ inputView: InputView) {
        cardHolderEntered = inputView.value
        cardHolderValidation = .VALID
        let cardHolderValidation = checkValidation(value: cardHolderEntered, validator: cardHolderValidator)
        factory.updateTextFieldModel(model: cardHolderFieldModel())
    }
    
    private func mandatoryFieldTextDidChange(_ inputView: InputView) {
        mandatoryFieldsValues[inputView.id] = inputView.value
        let validation = mandatoryFieldsProvider?.validateFieldValue(fieldId: inputView.id, inputView.value)
        if let mandatoryField = mandatoryFieldsProvider?.mandatoryField(forId: inputView.id) {
            let tableModel = TextFieldTableModel(
                id: mandatoryField.id,
                textFieldViewConfig: CardDataTextFieldViewState(
                    id: mandatoryField.id,
                    placeholder: mandatoryField.placeholder,
                    text: mandatoryFieldsValues[mandatoryField.id] ?? "",
                    pattern: .mandatoryField,
                    errorMessage: mandatoryFieldsValidations[mandatoryField.id]?.errorMessage ?? "",
                    textFieldViewTextDidChange: mandatoryFieldTextDidChange,
                    textFieldDoneButtonHandler: doneButtonHandler
                )
            )
            
            factory.updateTextFieldModel(
                model: tableModel
            )
        }
    }
    
    private func doneButtonHandler(_ inputView: InputView) {
        inputView.setFilled(!inputView.value.isEmpty)
        view.endEditing(true)
    }
}

extension SelectedCardViewController: InputTableVC {}
