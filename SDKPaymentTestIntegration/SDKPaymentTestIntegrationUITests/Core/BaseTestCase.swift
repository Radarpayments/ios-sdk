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
    private let dsRoot = """
    MIICDTCCAbOgAwIBAgIUOO3a573khC9kCsQJGKj/PpKOSl8wCgYIKoZIzj0EA
    wIwXDELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBA
    oMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDEVMBMGA1UEAwwMZHVtbXkzZHN
    yb290MB4XDTIxMDkxNDA2NDQ1OVoXDTMxMDkxMjA2NDQ1OVowXDELMAkGA1UE
    BhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoMGEludGVybmV0I
    FdpZGdpdHMgUHR5IEx0ZDEVMBMGA1UEAwwMZHVtbXkzZHNyb290MFkwEwYHKo
    ZIzj0CAQYIKoZIzj0DAQcDQgAE//e+MhwdgWxkFpexkjBCx8FtJ24KznHRXMS
    WabTrRYwdSZMScgwdpG1QvDO/ErTtW8IwouvDRlR2ViheGr02bqNTMFEwHQYD
    VR0OBBYEFHK/QzMXw3kW9UzY5w9LVOXr+6YpMB8GA1UdIwQYMBaAFHK/QzMXw
    3kW9UzY5w9LVOXr+6YpMA8GA1UdEwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSA
    AwRQIhAOPEiotH3HJPIjlrj9/0m3BjlgvME0EhGn+pBzoX7Z3LAiAOtAFtkip
    d9T5c9qwFAqpjqwS9sSm5odIzk7ug8wow4Q==
    """.trimmingCharacters(in: .whitespacesAndNewlines)
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
        userName: String = "mobile-sdk-api",
        password: String = "vkyvbG0",
        clientId: String? = nil,
        use3DS2SDK: Bool
    ) -> String {
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        
        let config: Use3DSConfig = use3DS2SDK
            ? .use3ds2sdk(dsRoot: dsRoot)
            : .noUse3ds2sdk

        paymentConfig = SDKPaymentConfig(baseURL: baseUrl,
                                         use3DSConfig: config,
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
    
    func getDefaultPaymentConfig() -> SDKPaymentConfig {
        guard let paymentConfig else {
            paymentConfig = SDKPaymentConfig(baseURL: baseUrl,
                                             use3DSConfig: .use3ds2sdk(dsRoot: dsRoot),
                                             keyProviderUrl: keyProviderUrl)
            return paymentConfig
        }
        
        return paymentConfig
    }
    
    func awaitAssert(timeout: TimeInterval = 5, _ assert: () -> Void) {
        let expectation = expectation(description: "Test after \(timeout) seconds")
        let _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
        expectation.fulfill()
        assert()
    }
}

