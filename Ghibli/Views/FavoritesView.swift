//
//  FavoritesView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/6/25.
//

import SwiftUI

struct FavoritesView: View {
  let filmsViewModel: FilmsViewModel
  let favoritesViewModel: FavoritesViewModel
  
  var films: [Film] {
    let favoritesIDs = favoritesViewModel.favoritesIDs
    if case let .success(films) = filmsViewModel.state {
      return filmsViewModel.films.filter { favoritesIDs.contains($0.id) }
    } else {
      return []
    }
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if films.isEmpty {
          ContentUnavailableView("No Favorites yet", systemImage: "heart")
        } else {
          FilmListView(
            films: films,
            favoritesViewModel: favoritesViewModel
          )
        }
      }
      .navigationTitle("Favorites")
    }
  }
}

#Preview {
  FavoritesView(
    filmsViewModel: FilmsViewModel(
      service: MockGhibliService()
    ),
    favoritesViewModel: FavoritesViewModel(
      service: MockFavoriteStorage()
    )
  )
}
