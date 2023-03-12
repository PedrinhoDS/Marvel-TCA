//
//  SwiftUIView.swift
//  
//
//  Created by Pedro Henrique on 3/7/23.
//

import SwiftUI
import ComposableArchitecture
import HeroClient
import Models
import Utils

public struct HeroListView: View {
    private let store: StoreOf<HeroList>
    
    public init(store: StoreOf<HeroList>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.content, id: \.id) { row in
                        NavigationLink(destination: EmptyView()) {
                            HeroRow(hero: row) {
                                viewStore.send(.didTouchFavoriteButton(hero: row))
                            }.onAppear {
                                viewStore.send(.heroAppeared(hero: row))
                            }
                        }
                    }
                    
                    if viewStore.state.isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .alert(
            store.scope(state: \.errorAlert),
            dismiss: .dismissErrorAlert
        )
        .searchable(text: ViewStore(store).binding(
            get: \.searchTerm,
            send: HeroList.Action.searchCharacter
        ))
        .navigationTitle("Characters")
        .onAppear { ViewStore(store).send(.fetchHeroes) }
    }
}

struct HeroRow: View {
    let hero: HeroModel
    let favoriteButtonAction: (() -> Void)

    public var body: some View {
        HStack {
            AsyncImage(url: hero.imageUrl) { image in
                image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        
            Text(hero.name)
            
            Spacer()
            
            Button(action: favoriteButtonAction, label: {
                Image(systemName: hero.isFavorite ? "star.fill" : "star")
            })
            .buttonStyle(PlainButtonStyle())

        }
    }
}


struct HeroList_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView(store: Store(
            initialState: HeroList.State(),
            reducer: HeroList()
        ) {
            $0.heroClient = .testValue
        }
        )
    }
}
