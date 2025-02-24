import Foundation


/// Card identifier.
/// - Parameters:
///     - value: Identifier value.
public enum CardIdentifier: Codable, Equatable {
    case newPaymentMethodIdentifier(String)
    case storedPaymentMethodIdentifier(String)

    enum CodingKeys: CodingKey {
        case newPaymentMethodIdentifier
        case storedPaymentMethodIdentifier
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(String.self, forKey: .newPaymentMethodIdentifier) {
            self = .newPaymentMethodIdentifier(value)
            return
        }
        if let value = try? container.decode(String.self, forKey: .storedPaymentMethodIdentifier) {
            self = .storedPaymentMethodIdentifier(value)
            return
        }
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown type of card identifier"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .newPaymentMethodIdentifier(let value):
                try container.encode(value, forKey: .newPaymentMethodIdentifier)
            case .storedPaymentMethodIdentifier(let value):
                try container.encode(value, forKey: .storedPaymentMethodIdentifier)
        }
    }
}
