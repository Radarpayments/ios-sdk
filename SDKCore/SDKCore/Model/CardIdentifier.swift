import Foundation


/// Card identifier.
/// - Parameters:
///     - value: Identifier value.
public enum CardIdentifier: Codable, Equatable {
    case cardPanIdentifier(String)
    case cardBindingIdIdentifier(String)

    enum CodingKeys: CodingKey {
        case cardPanIdentifier
        case cardBindingIdIdentifier
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(String.self, forKey: .cardPanIdentifier) {
            self = .cardPanIdentifier(value)
            return
        }
        if let value = try? container.decode(String.self, forKey: .cardBindingIdIdentifier) {
            self = .cardBindingIdIdentifier(value)
            return
        }
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown type of card identifier"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .cardPanIdentifier(let value):
                try container.encode(value, forKey: .cardPanIdentifier)
            case .cardBindingIdIdentifier(let value):
                try container.encode(value, forKey: .cardBindingIdIdentifier)
        }
    }
}
