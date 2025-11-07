//
//  ContentView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct ContentView: View {
  @State private var filmsViewModel = FilmsViewModel()
  
  var body: some View {
    TabView {
      Tab("Movies", systemImage: "movieclapper") {
        FilmsView(filmsViewModel: filmsViewModel)
      }
      Tab("Favorites", systemImage: "heart") {
        FavoritesView(filmsViewModel: filmsViewModel)
      }
      Tab("Settings", systemImage: "gear") {
        SettingsView()
      }
      Tab(role: .search) {
        SearchView()
      }
    }
  }
}

#Preview {
  ContentView()
}
