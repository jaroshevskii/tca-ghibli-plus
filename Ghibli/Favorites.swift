//
//  Favorites.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/10/25.
//

import ComposableArchitecture

@Reducer
struct Favorites {
  struct State: Equatable {
    @Shared(.favoritesIDs) var ids: Set<Film.ID>
  }
  
  enum Action {
    case toggle(Film.ID)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .toggle(filmID):
        state.$ids.withLock {
          if $0.contains(filmID) {
            $0.remove(filmID)
          } else {
            $0.insert(filmID)
          }
        }
        return .none
      }
    }
  }
}

extension SharedReaderKey where Self == AppStorageKey<Set<Film.ID>>.Default {
  static var favoritesIDs: Self {
    Self[.appStorage("FavoritesIDs"), default: []]
  }
}
