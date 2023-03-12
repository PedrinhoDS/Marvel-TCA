//
//  APIClient.swift
//  
//
//  Created by Pedro Henrique on 3/8/23.
//

import Foundation
import Dependencies

enum APIError: Error {
    case invalidURL
    case decodingError
}

enum DateError: String, Error {
    case invalidDate
}

public struct APIClient {
    private var customDateDecodingStartegy: @Sendable (Decoder) throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return { (decoder) throws -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            print("Invalid date", dateStr)
            throw DateError.invalidDate
        }
    }
    
    public init() { }
    
    public func fetchData<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard var url = MarvelURLComponents(endpoint: path).urlForCharacters else {
            throw APIError.invalidURL
        }
        
        url.append(queryItems: queryItems)
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(customDateDecodingStartegy)
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw APIError.decodingError
        }
    }
}

extension APIClient: TestDependencyKey {
    public static let testValue = APIClient()
    public static let liveValue = APIClient()
}

extension DependencyValues {
  public var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}
