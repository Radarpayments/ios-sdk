//
//  Defaults.swift
//  MyStore
//

import Foundation

struct SDKCoreDefaults {
    static let cardNumber = "4111111111111111"
    static let cardExpiry = "12/26"
    static let cardCode = "123"
    static let cardHolder = "CARDHOLDER NAME"
    static let storedPaymentMethodId = "pm_86mi3dqXzNgiFcrgzfZdPxVX9wdvb"
    static let mdOrder = "9cd7259b-05cd-4177-ba87-9f454bfd8f3c"
    static let bindingId = "baf36cea-ca32-417d-941d-ee91d02a0590"
    static let publicKey =
    "-----BEGIN PUBLIC KEY-----" +
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoIITqh9xlGx4tWA+aucb0V0YuFC9aXzJb0epdioSkq3qzNdRSZIxe/dHqcbMN2SyhzvN6MRVl3xyjGAV+lwk8poD4BRW3VwPUkT8xG/P/YLzi5N8lY6ILlfw6WCtRPK5bKGGnERcX5dqL60LhOPRDSYT5NHbbp/J2eFWyLigdU9Sq7jvz9ixOLh6xD7pgNgHtnOJ3Cw0Gqy03r3+m3+CBZwrzcp7ZFs41bit7/t1nIqgx78BCTPugap88Gs+8ZjdfDvuDM+/3EwwK0UVTj0SQOv0E5KcEHENL9QQg3ujmEi+zAavulPqXH5907q21lwQeemzkTJH4o2RCCVeYO+YrQIDAQAB" +
    "-----END PUBLIC KEY-----"
}

struct SDKPaymentDefaults {
    // Common
    static let apiPaymentUrl = "https://dev.bpcbt.com/payment"
    static let amount = "100"
    static let currency = "USD"
    static let merchantCustomerId = ""

    // API V1
    static let apiOrderUrl = "https://dev.bpcbt.com/payment/rest/register.do"
    static let merchantUserName = "i.malenko-v1-api"
    static let merchantPassword = "rkrvj-W3"
    static let returnUrl = "sdk://done"
    static let merchantOrderId = "1234567890"

    // API V2
    static let apiSessionUrl = "https://dev.bpcbt.com/api2/sessions"
    static let apiKey = "9yVrffWNAiHUUVUCQoX4NFHMxmRHYA2yB"
    static let apiVersion = "2023-10-31"
    static let successUrl = "sdk://done"
    static let failureUrl = "sdk://done"
}
