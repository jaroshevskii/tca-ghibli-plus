//
//  FilmsView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/6/25.
//

import SwiftUI

struct FilmsView: View {
  let filmsViewModel: FilmsViewModel
  let favoritesViewModel: FavoritesViewModel
  
  var body: some View {
    NavigationStack {
      Group {
        switch filmsViewModel.state {
        case .idle:
          Text("No films yer")
        case .loading:
          ProgressView {
            Text("Loading...")
          }
        case let .success(films):
          FilmListView(
            films: films,
            favoritesViewModel: favoritesViewModel
          )
        case let .error(error):
          Text(error)
            .foregroundStyle(.pink)
        }
      }
      .navigationTitle("Ghibli")
    }
  }
}

#Preview {
  FilmsView(
    filmsViewModel: FilmsViewModel(
      service: MockGhibliService()
    ),
    favoritesViewModel: FavoritesViewModel(
      service: MockFavoriteStorage()
    )
  )
}
