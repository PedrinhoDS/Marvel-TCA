import Foundation
import ComposableArchitecture
import HeroClient
import XCTest

@testable import Hero

@MainActor
final class HeroListTests: XCTestCase {
    
    func testFetchSearch() async {
        let store = TestStore(
            initialState: HeroList.State(),
            reducer: HeroList()) {
                $0.heroClient = .testValue
            }
        
        await store.send(.searchCharacter(searchTerm: "Spider Man")) {
            $0.searchTerm = "Spider Man"
        }
        await store.receive(.fetchHeroes) {
            $0.isLoading = true
        }
        await store.receive(.fetchHeroesResponse(.success([HeroModel.spiderMan]))) {
            $0.isLoading = false
            $0.content = [HeroModel.spiderMan]
        }
    }
    
    func testFetchMoreItems() async {
        let store = TestStore(
            initialState: HeroList.State(),
            reducer: HeroList()) {
                $0.heroClient.fetchList = { offset, _, _, _ in
                    if offset == 0 {
                        return .mock
                    } else {
                        return [.wolverine]
                    }
                }
            }
        
        await store.send(.fetchHeroes) {
            $0.isLoading = true
        }
        await store.receive(.fetchHeroesResponse(.success(.mock))) {
            $0.isLoading = false
            $0.content = .mock
        }
        
        await store.send(.heroAppeared(hero: HeroModel.spiderMan))
        await store.send(.heroAppeared(hero: HeroModel.ironMan))
        
        await store.receive(.fetchHeroes) {
            $0.isLoading = true
        }
        await store.receive(.fetchHeroesResponse(.success([.wolverine]))) {
            $0.isLoading = false
            $0.content = .mock + [.wolverine]
        }
    }
    
    func testFetchWithError() async {
        let store = TestStore(
            initialState: HeroList.State(),
            reducer: HeroList()) {
                $0.heroClient.fetchList = { offset, _, _, _ in
                    throw SomethingWentWrong()
                }
            }
        
        await store.send(.fetchHeroes) {
            $0.isLoading = true
        }
        await store.receive(.fetchHeroesResponse(.failure(SomethingWentWrong()))) {
            $0.isLoading = false
            $0.errorAlert = AlertState(title: { TextState("Something went wrong")})
        }
        await store.send(.dismissErrorAlert) {
            $0.errorAlert = nil
        }
    }
}

private struct SomethingWentWrong: Equatable, Error {}
