// Generated using Sourcery 1.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.9.0


import SwiftyMocky
import XCTest
import Foundation
@testable import SDKForms
@testable import SDKCore


// MARK: - CryptogramCipherTest

open class CryptogramCipherTestMock: CryptogramCipherTest, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func encode(data: String, key: Key) throws -> String {
        addInvocation(.m_encode__data_datakey_key(Parameter<String>.value(`data`), Parameter<Key>.value(`key`)))
		let perform = methodPerformValue(.m_encode__data_datakey_key(Parameter<String>.value(`data`), Parameter<Key>.value(`key`))) as? (String, Key) -> Void
		perform?(`data`, `key`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_encode__data_datakey_key(Parameter<String>.value(`data`), Parameter<Key>.value(`key`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for encode(data: String, key: Key). Use given")
			Failure("Stub return value not specified for encode(data: String, key: Key). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_encode__data_datakey_key(Parameter<String>, Parameter<Key>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_encode__data_datakey_key(let lhsData, let lhsKey), .m_encode__data_datakey_key(let rhsData, let rhsKey)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsData, rhs: rhsData, with: matcher), lhsData, rhsData, "data"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher), lhsKey, rhsKey, "key"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_encode__data_datakey_key(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_encode__data_datakey_key: return ".encode(data:key:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func encode(data: Parameter<String>, key: Parameter<Key>, willReturn: String...) -> MethodStub {
            return Given(method: .m_encode__data_datakey_key(`data`, `key`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func encode(data: Parameter<String>, key: Parameter<Key>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_encode__data_datakey_key(`data`, `key`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func encode(data: Parameter<String>, key: Parameter<Key>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_encode__data_datakey_key(`data`, `key`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func encode(data: Parameter<String>, key: Parameter<Key>) -> Verify { return Verify(method: .m_encode__data_datakey_key(`data`, `key`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func encode(data: Parameter<String>, key: Parameter<Key>, perform: @escaping (String, Key) -> Void) -> Perform {
            return Perform(method: .m_encode__data_datakey_key(`data`, `key`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - CryptogramProcessorTest

open class CryptogramProcessorTestMock: CryptogramProcessorTest, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func create(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo, registeredFrom: MSDKRegisteredFrom) throws -> String {
        addInvocation(.m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`)))
		let perform = methodPerformValue(.m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`))) as? (String, Int64, String, CoreCardInfo) -> Void
		perform?(`order`, `timestamp`, `uuid`, `cardInfo`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for create(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo). Use given")
			Failure("Stub return value not specified for create(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func create(applePayToken: String) -> String {
        addInvocation(.m_create__applePayToken_applePayToken(Parameter<String>.value(`applePayToken`)))
		let perform = methodPerformValue(.m_create__applePayToken_applePayToken(Parameter<String>.value(`applePayToken`))) as? (String) -> Void
		perform?(`applePayToken`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_create__applePayToken_applePayToken(Parameter<String>.value(`applePayToken`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for create(applePayToken: String). Use given")
			Failure("Stub return value not specified for create(applePayToken: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>, Parameter<Int64>, Parameter<String>, Parameter<CoreCardInfo>)
        case m_create__applePayToken_applePayToken(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(let lhsOrder, let lhsTimestamp, let lhsUuid, let lhsCardinfo), .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(let rhsOrder, let rhsTimestamp, let rhsUuid, let rhsCardinfo)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher), lhsOrder, rhsOrder, "order"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher), lhsTimestamp, rhsTimestamp, "timestamp"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUuid, rhs: rhsUuid, with: matcher), lhsUuid, rhsUuid, "uuid"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCardinfo, rhs: rhsCardinfo, with: matcher), lhsCardinfo, rhsCardinfo, "cardInfo"))
				return Matcher.ComparisonResult(results)

            case (.m_create__applePayToken_applePayToken(let lhsApplepaytoken), .m_create__applePayToken_applePayToken(let rhsApplepaytoken)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsApplepaytoken, rhs: rhsApplepaytoken, with: matcher), lhsApplepaytoken, rhsApplepaytoken, "applePayToken"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_create__applePayToken_applePayToken(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo: return ".create(order:timestamp:uuid:cardInfo:)"
            case .m_create__applePayToken_applePayToken: return ".create(applePayToken:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func create(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, willReturn: String...) -> MethodStub {
            return Given(method: .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func create(applePayToken: Parameter<String>, willReturn: String...) -> MethodStub {
            return Given(method: .m_create__applePayToken_applePayToken(`applePayToken`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func create(applePayToken: Parameter<String>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_create__applePayToken_applePayToken(`applePayToken`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
        public static func create(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func create(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, willProduce: (StubberThrows<String>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func create(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>) -> Verify { return Verify(method: .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`))}
        public static func create(applePayToken: Parameter<String>) -> Verify { return Verify(method: .m_create__applePayToken_applePayToken(`applePayToken`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func create(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, perform: @escaping (String, Int64, String, CoreCardInfo) -> Void) -> Perform {
            return Perform(method: .m_create__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), performs: perform)
        }
        public static func create(applePayToken: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_create__applePayToken_applePayToken(`applePayToken`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - KeyProviderTest

open class KeyProviderTestMock: KeyProviderTest, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func provideKey() throws -> Key {
        addInvocation(.m_provideKey)
		let perform = methodPerformValue(.m_provideKey) as? () -> Void
		perform?()
		var __value: Key
		do {
		    __value = try methodReturnValue(.m_provideKey).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for provideKey(). Use given")
			Failure("Stub return value not specified for provideKey(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_provideKey

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_provideKey, .m_provideKey): return .match
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_provideKey: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_provideKey: return ".provideKey()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func provideKey(willReturn: Key...) -> MethodStub {
            return Given(method: .m_provideKey, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func provideKey(willThrow: Error...) -> MethodStub {
            return Given(method: .m_provideKey, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func provideKey(willProduce: (StubberThrows<Key>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_provideKey, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Key).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func provideKey() -> Verify { return Verify(method: .m_provideKey)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func provideKey(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_provideKey, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - PaymentStringProcessorTest

open class PaymentStringProcessorTestMock: PaymentStringProcessorTest, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func createPaymentString(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo, registeredFrom: MSDKRegisteredFrom) -> String {
        addInvocation(.m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`)))
		let perform = methodPerformValue(.m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`))) as? (String, Int64, String, CoreCardInfo) -> Void
		perform?(`order`, `timestamp`, `uuid`, `cardInfo`)
		var __value: String
		do {
		    __value = try methodReturnValue(.m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>.value(`order`), Parameter<Int64>.value(`timestamp`), Parameter<String>.value(`uuid`), Parameter<CoreCardInfo>.value(`cardInfo`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for createPaymentString(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo). Use given")
			Failure("Stub return value not specified for createPaymentString(order: String, timestamp: Int64, uuid: String, cardInfo: CoreCardInfo). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(Parameter<String>, Parameter<Int64>, Parameter<String>, Parameter<CoreCardInfo>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(let lhsOrder, let lhsTimestamp, let lhsUuid, let lhsCardinfo), .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(let rhsOrder, let rhsTimestamp, let rhsUuid, let rhsCardinfo)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOrder, rhs: rhsOrder, with: matcher), lhsOrder, rhsOrder, "order"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTimestamp, rhs: rhsTimestamp, with: matcher), lhsTimestamp, rhsTimestamp, "timestamp"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUuid, rhs: rhsUuid, with: matcher), lhsUuid, rhsUuid, "uuid"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCardinfo, rhs: rhsCardinfo, with: matcher), lhsCardinfo, rhsCardinfo, "cardInfo"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo: return ".createPaymentString(order:timestamp:uuid:cardInfo:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func createPaymentString(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, willReturn: String...) -> MethodStub {
            return Given(method: .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func createPaymentString(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, willProduce: (Stubber<String>) -> Void) -> MethodStub {
            let willReturn: [String] = []
			let given: Given = { return Given(method: .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (String).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func createPaymentString(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>) -> Verify { return Verify(method: .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func createPaymentString(order: Parameter<String>, timestamp: Parameter<Int64>, uuid: Parameter<String>, cardInfo: Parameter<CoreCardInfo>, perform: @escaping (String, Int64, String, CoreCardInfo) -> Void) -> Perform {
            return Perform(method: .m_createPaymentString__order_ordertimestamp_timestampuuid_uuidcardInfo_cardInfo(`order`, `timestamp`, `uuid`, `cardInfo`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

