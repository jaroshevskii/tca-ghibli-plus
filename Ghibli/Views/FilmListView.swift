//
//  FilmListView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct FilmListView: View {
  var films: [Film]
  let favoritesViewModel: FavoritesViewModel
  
  var body: some View {
    List(films) { film in
      NavigationLink(value: film) {
        FilmRow(film: film, favoritesViewModel: favoritesViewModel)
      }
    }
    .navigationDestination(for: Film.self) { film in
      FilmDetailView(
        film: film,
        favoritesViewModel: favoritesViewModel
      )
    }
  }
}

fileprivate struct FilmRow: View {
  let film: Film
  let favoritesViewModel: FavoritesViewModel
  
  var isFavorite: Bool {
    favoritesViewModel.isFavorite(filmID: film.id)
  }
  
  var body: some View {
    HStack(alignment: .top) {
      FilmImageView(urlPath: film.image)
        .frame(width: 100, height: 150)
      
      VStack(alignment: .leading) {
        HStack {
          Text(film.title)
            .bold()
          
          Spacer()
          
          FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
            .buttonStyle(.plain)
            .controlSize(.large)
        }
        .padding(.bottom, 5)
        
        Group {
          Text("Directed by \(film.director)")
          Text("Released: \(film.releaseDate)")
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
      }
      .padding(.top)
    }
  }
}

//#Preview {
//  @Previewable @State var favoritesViewModel = FavoritesViewModel(
//    service: MockFavoriteStorage()
//  )
//  
//  NavigationStack {
//    FilmListView(films: [Film.mock], favoritesViewModel: favoritesViewModel)
//  }
//  .task {
//    favoritesViewModel.load()
//  }
//}
