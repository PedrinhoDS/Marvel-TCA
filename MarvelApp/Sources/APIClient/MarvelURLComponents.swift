import Foundation
import CryptoKit

public enum OrderBy: String {
    case name
    case modified
    case startDate
}

struct MarvelURLComponents {
    private let scheme = "https"
    private let host = "gateway.marvel.com"
    private let port = 443
    private let publicKey = Constants.publicKey
    private let privateKey = Constants.privateKey
    private let endpoint: String

    private var queryItems: [URLQueryItem] {
        let timeStamp = "\(Date().timeIntervalSince1970)"
        return [
            .init(name: "ts", value: timeStamp),
            .init(name: "apikey", value: publicKey),
            .init(name: "hash", value: hash(for: timeStamp + privateKey + publicKey))
        ]
    }

    private func url(for path: String) -> URL?  {
        var components = URLComponents(url: Constants.host, resolvingAgainstBaseURL: true)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }

    private func hash(for string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    var urlForCharacters: URL? {
        url(for: endpoint)
    }

    public init(endpoint: String) {
        self.endpoint = endpoint
    }
}
