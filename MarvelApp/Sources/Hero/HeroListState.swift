//
//  File.swift
//  
//
//  Created by Pedro Henrique on 3/8/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import HeroClient

public struct HeroList: ReducerProtocol {
    
    @Dependency(\.heroClient) var heroClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.heroStorage) var heroStorage
    
    private enum SearchCharactersID {}

    public init() {}
    
    public struct State: Equatable {
        var errorAlert: AlertState<Action>? = nil
        var content: [HeroModel] = []
        var searchTerm: String = ""
        var isLoading: Bool = false
        
        public init(
            errorAlert: AlertState<Action>? = nil,
            content: [HeroModel] = [],
            searchTerm: String = "",
            isLoading: Bool = false
        ) {
            self.errorAlert = errorAlert
            self.content = content
            self.searchTerm = searchTerm
            self.isLoading = isLoading
        }
    }
    
    public enum Action: Equatable {
        case fetchHeroesResponse(TaskResult<[HeroModel]>)
        case fetchHeroes
        case heroAppeared(hero: HeroModel)
        case searchCharacter(searchTerm: String)
        case dismissErrorAlert
        case didTouchFavoriteButton(hero: HeroModel)
        case updateFavoriteHero(index: Int)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchHeroes:
            guard !state.isLoading else { return .none }
            state.isLoading = true
            
            return .task { [offset = state.content.count, searchTerm = state.searchTerm] in
                    .fetchHeroesResponse(
                        await TaskResult {
                            try await heroClient.fetchList(offset, searchTerm, apiClient, heroStorage.fetchFavorites)
                        }
                    )
            }
        case let .fetchHeroesResponse(.success(data)):
            state.isLoading = false
            state.content += data
            return .none
        case .fetchHeroesResponse(.failure):
            state.isLoading = false
            state.errorAlert = AlertState(title: {
                TextState("Something went wrong")
            })
            
            return .none
        case let .heroAppeared(hero):
            if state.content.last == hero {
                return .send(.fetchHeroes)
            }
            
            return .none
            
        case let .searchCharacter(searchTerm):
            state.searchTerm = searchTerm
            state.content = []
            return .send(.fetchHeroes)
        case .dismissErrorAlert:
            state.errorAlert = nil
            return .none
        case let .didTouchFavoriteButton(hero):
            guard let index = state.content.firstIndex(of: hero) else { return .none }
            let isFavorite = state.content[index].isFavorite
            
            return .concatenate(
                .fireAndForget {
                    if isFavorite {
                        try heroStorage.removeFavorite(hero.id)
                    } else {
                        try heroStorage.storeFavorite(hero.id)
                    }
                },
                .send(.updateFavoriteHero(index: index))
            )
        case let .updateFavoriteHero(index):
            state.content[index].isFavorite.toggle()
            return .none
        }
    }
}
