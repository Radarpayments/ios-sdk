//
//  KeyProviderMock.swift
//  SDKPaymentTests
//
//
//

@testable import SDKCore
@testable import SDKPayment

final class KeyProviderMock: KeyProvider {

    var result: Result<Key, Error> = .success(Key(value: "", protocol: "", expiration: 0))
    private(set) var provideKeyCallsCount = 0

    func provideKey() throws -> Key {
        provideKeyCallsCount += 1

        return try result.get()
    }
}
