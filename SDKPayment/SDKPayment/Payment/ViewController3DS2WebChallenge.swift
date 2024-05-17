//
//  ViewController3DS2WebChallenge.swift
//  SDKPayment
//
// 
//

import UIKit
import WebKit
import SDKForms

public final class ViewController3DS2WebChallenge: UIViewController {
    
    private lazy var webView: WKWebView = { WKWebView() }()
    private var noActionTimer: Timer?

    private var webChallengeParam: WebChallengeParam!
    private weak var viewControllerDelegate: ViewControllerDelegate!

    private lazy var paymentApi: PaymentApi = {
        PaymentApiImpl(baseUrl: viewControllerDelegate.getPaymentConfig().baseURL)
    }()
    
    convenience public init(
        webChallengeParam: WebChallengeParam,
        viewControllerDelegate: ViewControllerDelegate?
    ) {
        self.init()

        self.webChallengeParam = webChallengeParam
        self.viewControllerDelegate = viewControllerDelegate
    }
    
    override public func loadView() {
        super.loadView()
        
        setupSubviews()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        noActionTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { [weak self] timer in
            guard let self else { return }
            
            timer.invalidate()
            
            let paymentResult = PaymentResult(
                mdOrder: webChallengeParam.mdOrder,
                isSuccess: false, 
                exception: SDKTransactionException(message: "Transaction Timed Out.")
            )
            viewControllerDelegate?.finishWithResult(paymentData: paymentResult)
        })
        
        setupWebView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        noActionTimer?.invalidate()
    }
    
    private func setupSubviews() {
        view = webView
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        
        let html = getHtmlString()
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    private func getHtmlString() -> String {
        """
        <html>
        <head><title>ACS Redirect</title></head>
        <body onload="document.forms['acs'].submit()">
        ACS Redirect
        <form id="acs" method="post" action="\(webChallengeParam.acsUrl)">
            <input type="hidden" id="MD" name="MD" value="\(webChallengeParam.mdOrder)"/>
            <input type="hidden" id="PaReq" name="PaReq" value="\(webChallengeParam.paReq)"/>
            <input type="hidden" id="TermUrl" name="TermUrl" value="\(webChallengeParam.termUrl)"/>
        </form>
        </body>
        </html>
        """
    }
    
    private func finishPayment() {
        do {
            let orderStatus = try paymentApi
                .getSessionStatus(mdOrder: webChallengeParam.mdOrder)
            
            let paymentFinishedInfo = try paymentApi
                .getFinishedPaymentInfo(orderId: webChallengeParam.mdOrder)
            
            let isSuccess = paymentFinishedInfo.status?
                .containsAnyOfKeywordIgnoreCase(keywords: OrderStatuses.payedStatuses) ?? false
            
            let paymentResult = PaymentResult(
                mdOrder: webChallengeParam.mdOrder,
                isSuccess: isSuccess
            )
            
            LogDebug.shared.logIfDebug(message: "getSessionStatus - Remaining sec \(orderStatus.remainingSecs)")
            
            viewControllerDelegate?.finishWithResult(paymentData: paymentResult)
            
        } catch {
            let paymentResult = PaymentResult(
                mdOrder: webChallengeParam.mdOrder,
                isSuccess: false, 
                exception: error as? SDKException
            )
            viewControllerDelegate?.finishWithResult(paymentData: paymentResult)
        }

        dismissController()
    }
    
    private func dismissController() {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.noActionTimer?.invalidate()
        }
    }
    
    private func finishTimer() {
        noActionTimer?.invalidate()
    }
}

extension ViewController3DS2WebChallenge: WKNavigationDelegate {
    
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let request = navigationAction.request
        
        guard let absoluteString = request.url?.absoluteString
        else {
            decisionHandler(.allow)
            return
        }
        
        print("absoluteString: \(absoluteString)")
        if absoluteString.contains("sdk://done") {
            finishPayment()
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
