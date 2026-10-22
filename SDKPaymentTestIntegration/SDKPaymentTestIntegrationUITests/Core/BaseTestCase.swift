//
//  BaseTestCase.swift
//  SDKPaymentIntegrationUITests
//
//
//

import XCTest
import SDKPaymentTestIntegration
import SDKPayment

class BaseTestCase: XCTestCase {
    
    var app: XCUIApplication!
    
    var paymentConfig: SDKPaymentConfig!
    var testOrderHelper: TestOrderHelper!
    
    var testClientIdHelper: TestClientIdHelper!
    
    private let baseUrl = "https://dev.bpcbt.com/payment"
    private let keyProviderUrl = "https://dev.bpcbt.com/payment/se/keys.do"
    
    override func setUp() {
        super.setUp()

        testOrderHelper = TestOrderHelper(baseUrl: baseUrl)
        testClientIdHelper = TestClientIdHelper(
            startClientId: Int64(Date().timeIntervalSince1970)
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        app = nil
        paymentConfig = nil
        testOrderHelper = nil
        testClientIdHelper = nil
    }

    func registerOrderAndLaunchApp(
        amount: Int = 20000,
        returnUrl: String = "sdk://done",
        userName: String = TestCredentials.merchantLogin,
        password: String = TestCredentials.merchantPassword,
        clientId: String? = nil
    ) -> String {
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]

        paymentConfig = SDKPaymentConfig(baseURL: baseUrl,
                                         keyProviderUrl: keyProviderUrl)
        _ = SdkPayment.getSDKVersion()

        let orderId = try! testOrderHelper.registerOrder(
            amount: amount,
            returnUrl: returnUrl,
            userName: userName,
            password: password,
            clientId: clientId
        )
        
        let paymentConfig = testOrderHelper.encodeConfig(
            paymentConfig: paymentConfig
        )
        app.launchEnvironment = [
            "paymentConfig": paymentConfig,
            "orderId": orderId
        ]
        app.launch()
        
        return orderId
    }
    
    func registerOrderAndLaunchAppWithPreFilledBiilingData(
        amount: Int = 20000,
        returnUrl: String = "sdk://done",
        userName: String = TestCredentials.merchantLogin,
        password: String = TestCredentials.merchantPassword,
        clientId: String? = nil,
        email: String = "test@test.com",
        mobilePhone: String = "+35799902871",
        billingPayerData: BillingPayerData = BillingPayerData()
    ) -> String {
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]

        paymentConfig = SDKPaymentConfig(baseURL: baseUrl,
                                         keyProviderUrl: keyProviderUrl)
        _ = SdkPayment.getSDKVersion()

        let orderId = try! testOrderHelper.registerOrder(
            amount: amount,
            returnUrl: returnUrl,
            userName: userName,
            password: password,
            clientId: clientId,
            email: email,
            mobilePhone: mobilePhone,
            billingPayerData: billingPayerData
        )
        
        let paymentConfig = testOrderHelper.encodeConfig(
            paymentConfig: paymentConfig
        )
        app.launchEnvironment = [
            "paymentConfig": paymentConfig,
            "orderId": orderId,
        ]
        app.launch()
        
        return orderId
    }
    
    func registerSessionAndLaunchApp(
        createSessionbaseUrl: String = "https://dev.bpcbt.com",
        amount: Int = 2000,
        apiKey: String = TestCredentials.apiKey
    ) -> String {
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        
        paymentConfig = SDKPaymentConfig(baseURL: self.baseUrl,
                                         keyProviderUrl: keyProviderUrl)
        _ = SdkPayment.getSDKVersion()
        
        let sessionId = testOrderHelper.registerNewSession(createSessionbaseUrl: createSessionbaseUrl, amount: amount, apiKey: apiKey)
        
        let paymentConfig = testOrderHelper.encodeConfig(
            paymentConfig: paymentConfig
        )
        app.launchEnvironment = [
            "paymentConfig": paymentConfig,
            "sessionId": sessionId
        ]
        app.launch()
        
        return sessionId
    }
    
    func getDefaultPaymentConfig() -> SDKPaymentConfig {
        guard let paymentConfig else {
            paymentConfig = SDKPaymentConfig(baseURL: baseUrl,
                                             keyProviderUrl: keyProviderUrl)
            return paymentConfig
        }
        
        return paymentConfig
    }
    
    func awaitAssert(timeout: TimeInterval = 8, _ assert: () -> Void) {
        let expectation = expectation(description: "Test after \(timeout) seconds")
        let _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
        expectation.fulfill()
        assert()
    }
}

