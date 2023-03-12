//
//  File.swift
//  
//
//  Created by Pedro Henrique on 3/12/23.
//

import Foundation
import Dependencies

public typealias FetchFavorites = (@Sendable () async throws -> [Int])

public struct HeroStorage: Sendable {

    public var fetchFavorites: FetchFavorites
    public var storeFavorite: @Sendable (Int) throws -> Void
    public var removeFavorite: @Sendable (Int) throws -> Void

    public init(fetchFavorites: @escaping FetchFavorites, storeFavorite: @escaping @Sendable (Int) -> Void, removeFavorite: @escaping @Sendable (Int) -> Void) {
        self.fetchFavorites = fetchFavorites
        self.storeFavorite = storeFavorite
        self.removeFavorite = removeFavorite
    }
}

extension HeroStorage: DependencyKey {
    private enum Constants {
        static let heroKey: String = "marvel.app.hero.favorite"
    }
    
    public static var liveValue: HeroStorage = Self {
        UserDefaults.standard.array(forKey: Constants.heroKey) as? [Int] ?? []
    } storeFavorite: { id in
        var favorites = UserDefaults.standard.array(forKey: Constants.heroKey) as? [Int] ?? []
        favorites.append(id)
        UserDefaults.standard.set(favorites, forKey: Constants.heroKey)
    } removeFavorite: { id in
        var favorites = UserDefaults.standard.array(forKey: Constants.heroKey) as? [Int] ?? []
        favorites.removeAll { $0 == id }
        UserDefaults.standard.set(favorites, forKey: Constants.heroKey)
    }
}


extension HeroStorage: TestDependencyKey {
    public static var testValue: HeroStorage = Self {
        []
    } storeFavorite: { _ in
        
    } removeFavorite: { _ in
        
    }
    
    public static var previewValue: HeroStorage = Self {
        []
    } storeFavorite: { _ in
        
    } removeFavorite: { _ in
        
    }
}

extension DependencyValues {
    public var heroStorage: HeroStorage {
        get { self[HeroStorage.self] }
        set { self[HeroStorage.self] = newValue }
    }
}
