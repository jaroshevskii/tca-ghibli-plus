//
//  SearchView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/7/25.
//

import SwiftUI

struct SearchView: View {
  @State private var text = ""
  @State private var searchViewModel: SearchFilmsViewModel
  let favoritesViewModel: FavoritesViewModel
  
  init(
    searchViewModel: SearchFilmsViewModel = SearchFilmsViewModel(),
    favoritesViewModel: FavoritesViewModel
  ) {
    self.searchViewModel = searchViewModel
    self.favoritesViewModel = favoritesViewModel
  }

  var body: some View {
    NavigationStack {
      VStack {
        switch searchViewModel.state {
        case .idle:
          Text("Show search here")
        case .loading:
          ProgressView()
        case let .success(films):
          FilmListView(films: films, favoritesViewModel: favoritesViewModel)
        case let .error(error):
          Text(error)
        }
      }
      .searchable(text: $text)
      .task(id: text) {
        await searchViewModel.fetch(for: text)
      }
    }
  }
}

#Preview {
  SearchView(
    searchViewModel: SearchFilmsViewModel(
      service: MockGhibliService()
    ),
    favoritesViewModel: FavoritesViewModel(
      service: MockFavoriteStorage()
    )
  )
}
