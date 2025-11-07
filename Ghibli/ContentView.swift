//
//  ContentView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct ContentView: View {
  @State private var filmsViewModel = FilmsViewModel()
  @State private var favoritesViewModel = FavoritesViewModel()
  
  var body: some View {
    TabView {
      Tab("Movies", systemImage: "movieclapper") {
        FilmsView(
          filmsViewModel: filmsViewModel,
          favoritesViewModel: favoritesViewModel
        )
      }
      Tab("Favorites", systemImage: "heart") {
        FavoritesView(
          filmsViewModel: filmsViewModel,
          favoritesViewModel: favoritesViewModel
        )
      }
      Tab("Settings", systemImage: "gear") {
        SettingsView()
      }
      Tab(role: .search) {
        SearchView(favoritesViewModel: favoritesViewModel)
      }
    }
    .task {
      favoritesViewModel.load()
      await filmsViewModel.fetch()
    }
  }
}

#Preview {
  ContentView()
}
