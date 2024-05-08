//
//  PaymentBottomSheetViewController.swift
//  SDKForms
//
// 
//

import UIKit

protocol PaymentBottomSheetDelegate: AnyObject {
    
    func selectCard(_ card: Card)
    func selectAddNewCard()
    func selectAllPaymentMethods()
    func onClickApplePay()
}

public final class PaymentBottomSheetViewController: FormsBaseViewController {
    
    private struct Constants {
        static let applePay = "applePay"
        static let dividerHeader = "dividerHeader"
        static let paymentsMethods = "paymentsMethods"
    }
    
    private weak var delegate: PaymentBottomSheetDelegate?

    public var presentationMaxHeight: CGFloat {
        UIScreen.main.bounds.height - 100
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ThemeSetting.shared.colorTableBackground()
        
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let closeImage = assetsResolver.resolveClose(
            theme: ThemeSetting.shared.getTheme()
        )
        if let closeImage {
            button.setImage(
                UIImage(resource: ImageResource(name: closeImage, bundle: .sdkFormsBundle)), 
                for: .normal
            )
        }
        
        return button
    }()
    
    private var tableViewMinHeightConstraint: NSLayoutConstraint?
    
    public lazy var driver: BottomSheetTransitionDriver? = BottomSheetTransitionDriver(controller: self)
    public var tableContentSizeObserver: NSKeyValueObservation?
    
    private let factory = PaymentBottomSheetVCFactory()
    
    private let formatter = CardNumberFormatter()
    private let assetsResolver = AssetsResolver()
    
    private var paymentConfig: PaymentConfig?
    
    convenience init(
        paymentConfig: PaymentConfig,
        delegate: PaymentBottomSheetDelegate?,
        callbackHandler: any ResultCryptogramCallback<CryptogramData>
    ) {
        self.init()

        self.paymentConfig = paymentConfig
        self.delegate = delegate
        self.callbackHandler = callbackHandler
    }
    
    override public func loadView() {
        super.loadView()
        
        factory.setTableView(tableView: tableView)
        factory.setOwner(self)

        setupSubviews()
        setupLayout()
        setupCloseButton()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        updateSections()
    }
    
    private func updateSections() {
        var sections = [PaymentBottomSheetVCSection]()

        if (paymentConfig?.displayApplePay ?? false) {
            sections.append(
                PaymentBottomSheetVCSection(
                    type: .applePay,
                    items: [applePayModel()]
                )
            )
        }
        
        var items: [AnyHashable] = cardsItemsModels()
        items.append(addNewCardModel())
        items.append(paymentsMethodsModel())
        
        let header = (paymentConfig?.displayApplePay ?? false)
            ? dividerHeader()
            : nil
        
        sections.append(
            PaymentBottomSheetVCSection(
                type: .cards,
                header: header,
                items: items
            )
        )
        
        factory.updateSections(sections: sections)
    }
    
    private func applePayModel() -> ApplePayTableModel {
        ApplePayTableModel(id: Constants.applePay)
    }
    
    private func dividerHeader() -> DividerTableHeaderModel {
        DividerTableHeaderModel(
            id: Constants.dividerHeader,
            title: .payByCard()
        )
    }
    
    private func cardsItemsModels() -> [AnyHashable] {
        guard let cards = paymentConfig?.cards else { return [] }

        return cards.map {
            let cardLogoName = assetsResolver.resolveByPan(pan: $0.pan)

            return BindingCardTableModel(
                id: $0.bindingId,
                cardSystemImageName: cardLogoName,
                cardNumberText: formatter.maskCardNumber(pan: $0.pan),
                cardExpiryText: $0.expiryDate?.formatExpiryDate() ?? ""
            )
        }
    }
    
    private func addNewCardModel() -> AddNewCardTableModel {
        let leftImageName = assetsResolver
            .resolveAddCard(theme: ThemeSetting.shared.getTheme())
        
        return AddNewCardTableModel(
            leftImageName: leftImageName,
            title: .addCard()
        )
    }
    
    private func paymentsMethodsModel() -> PaymentsMethodsTableModel {
        PaymentsMethodsTableModel(
            id: Constants.paymentsMethods,
            title: .allPaymentMethods()
        )
    }
    
    private func setupSubviews() {
        tableContentSizeObserver = tableView.observe(
            \.contentSize,
             options: [.old, .new],
             changeHandler: { [weak self] _, changedValue in
                 guard let self else { return }

                 if let oldSize = changedValue.oldValue,
                    let newSize = changedValue.newValue,
                    oldSize.height != newSize.height {
                     self.updateHeightView(tableHeight: newSize.height)
                 }
             }
        )
        
        view.backgroundColor = ThemeSetting.shared.colorTableBackground()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        tableView.delegate = factory
        tableView.dataSource = factory
    }
    
    private func setupLayout() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        tableViewMinHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44),
                tableViewMinHeightConstraint ?? tableView.heightAnchor.constraint(equalToConstant: 44),
                
                closeButton.heightAnchor.constraint(equalToConstant: 32),
                closeButton.widthAnchor.constraint(equalToConstant: 32),
                closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ]
        )
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(clickOnCloseButton), for: .touchUpInside)
    }
    
    @objc
    private func clickOnCloseButton() {
        dismiss(animated: true)
    }
}

extension PaymentBottomSheetViewController: BottomSheetPresentable {

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
            CoverVerticalPresentAnimatedTransitioning()
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        CoverVerticalDismissAnimatedTransitioning()
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        driver
    }
    
    public func updateHeightView(tableHeight: CGFloat) {
        if tableView.contentSize.height == tableHeight {
            self.tableViewMinHeightConstraint?.constant = tableHeight
            
            UIView.animate(withDuration: 0.2) {
                self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
            
            self.tableView.isScrollEnabled = self.tableView.bounds.height < self.tableView.contentSize.height
        }
    }
}

extension PaymentBottomSheetViewController: CardListSelectable {

    func onClickCard(withId id: String) {
        guard let card = paymentConfig?.cards
            .first(where: { $0.bindingId == id })
        else { return }
        
        actionWasCalled = true
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.delegate?.selectCard(card)
        }
    }
    
    func onClickAddNewCard() {
        actionWasCalled = true
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.delegate?.selectAddNewCard()
        }
    }
    
    func onClickAllPayments() {
        actionWasCalled = true
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.delegate?.selectAllPaymentMethods()
        }
    }
}

extension PaymentBottomSheetViewController: ApplePayTableCellDelegate {
    
    func clickOnApplePayButton() {
        actionWasCalled = true
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.delegate?.onClickApplePay()
        }
    }
}
