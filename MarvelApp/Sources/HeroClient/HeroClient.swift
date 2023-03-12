//
//  HeroClient.swift
//  
//
//  Created by Pedro Henrique on 3/8/23.
//

import Dependencies
import APIClient
import Foundation
import Models
import Utils

public struct HeroManager: Sendable {
    public var fetchList: @Sendable (Int, String, APIClient, FetchFavorites) async throws -> [HeroModel]

    public init(
        fetchList: @escaping @Sendable (Int, String, APIClient, FetchFavorites) async throws -> [HeroModel]
    ) {
        self.fetchList = fetchList
    }
}

extension HeroManager: DependencyKey {
    public static let liveValue = Self(
        fetchList: { offset, name, apiClient, fetchFavorites in
            let endpoint = "/v1/public/characters"
            var query: [URLQueryItem] = [
                .init(name: "offset", value: String(describing: offset)),
            ]
            
            if !name.isEmpty {
                query.append(.init(name: "nameStartsWith", value: name))
            }
            
            let response: ResponseWrapper<MarvelCharacter> = try await apiClient.fetchData(path: endpoint, queryItems: query)
            let data = response.data.results
            let favoriteIds = try await fetchFavorites()
            
            return data.map { $0.mapToHeroModel(isFavorite: favoriteIds.contains($0.id)) }
        }
    )
}

#if DEBUG
extension HeroManager: TestDependencyKey {
    public static let testValue = HeroManager(
        fetchList: { offset, search, _, _ in
            guard offset == 0 else { return [] }
            let data: [HeroModel] = .mock
            return data.filter { $0.name.starts(with: search) }
        }
    )
}
#endif

extension DependencyValues {
    public var heroClient: HeroManager {
        get { self[HeroManager.self] }
        set { self[HeroManager.self] = newValue }
    }
}
