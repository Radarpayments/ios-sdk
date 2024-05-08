//
//  AutoMockable.swift
//  SDKForms
//
// 
//

import SDKCore

protocol AutoMockable {}
protocol KeyProviderTest: KeyProvider, AutoMockable {}
protocol PaymentStringProcessorTest: PaymentStringProcessor, AutoMockable {}
protocol CryptogramProcessorTest: CryptogramProcessor, AutoMockable {}
protocol CryptogramCipherTest: CryptogramCipher, AutoMockable {}
