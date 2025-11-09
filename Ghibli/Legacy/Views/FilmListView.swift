//
//  FilmListView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct FilmListView: View {
    
    var films: [LegacyFilm]
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        
        List(films) { film in
            NavigationLink(value: film) {
               FilmRow(film: film,
                       favoritesViewModel: favoritesViewModel)
            }
            
        }
        .navigationDestination(for: LegacyFilm.self) { film in
            FilmDetailScreen(film: film,
                             favoritesViewModel: favoritesViewModel)
        }
        
    }
}

private struct FilmRow: View {
    
    let film: LegacyFilm
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(urlPath: film.image)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(film.title)
                        .bold()
                    
                    Spacer()
                    FavoriteButton(filmID: film.id,
                                   favoritesViewModel: favoritesViewModel)
                    .buttonStyle(.plain)
                    .controlSize(.large)
                }
                .padding(.bottom, 5)
                
                Text("Directed by \(film.director)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Released: \(film.releaseYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
    }
}



#Preview {

    //@State @Previewable var filmsViewModel = FilmsViewModel(service: MockGhibliService())
    @State @Previewable var favorites = FavoritesViewModel(service: MockFavoriteStorage())
    
    NavigationStack {
        FilmListView(films: [LegacyFilm.example, LegacyFilm.exampleFavorite],
                     favoritesViewModel: favorites)
    }
    .task {
        favorites.load()
    }
}


