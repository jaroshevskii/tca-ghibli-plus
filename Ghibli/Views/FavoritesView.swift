//
//  FavoritesView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/6/25.
//

import SwiftUI

struct FavoritesView: View {
  let filmsViewModel: FilmsViewModel
  
  var films: [Film] {
    // TODO: get favorites
    // retrieve ids from storage
    // get data for favorite ids from films data
    return []
  }
  
  var body: some View {
    NavigationStack {
      Group {
        if films.isEmpty {
          ContentUnavailableView("No Favorites yet", systemImage: "heart")
        } else {
          FilmListView(films: films)
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
    )
  )
}
