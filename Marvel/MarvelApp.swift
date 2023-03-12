//
//  MarvelApp.swift
//  Marvel
//
//  Created by Pedro Henrique on 3/6/23.
//

import SwiftUI
import Hero
import ComposableArchitecture

@main
struct MarvelApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HeroListView(
                    store: Store(
                        initialState: HeroList.State(),
                        reducer: HeroList()
                    )
                ).tabItem {
                    Label("Heroes", systemImage: "figure.baseball")
                }
            }
        }
    }
}
