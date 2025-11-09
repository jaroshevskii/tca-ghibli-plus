//
//  FilmsList.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/9/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct FilmsList {
  @ObservableState
  struct State: Equatable {
    @Shared(.films) var films: IdentifiedArrayOf<Film> = []
  }
  
  enum Action {
    case task
    case filmsResponse(Result<IdentifiedArrayOf<Film>, any Error>)
  }
  
  @Dependency(\.ghibli) var ghibli
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .task:
        return .run { send in
          await send(.filmsResponse(Result { try await ghibli.films() }))
        }
        
      case let .filmsResponse(.success(films)):
        state.$films.withLock { $0 = films }
        return .none
      
      case .filmsResponse:
        return .none
      }
    }
  }
}

struct FilmsListView: View {
  let store: StoreOf<FilmsList>
  
  var body: some View {
    List(store.films) { film in
      FilmCardView(film: film)
    }
    .task { await store.send(.task).finish() }
    .navigationTitle("Ghibli")
  }
}

#Preview {
  NavigationStack {
    FilmsListView(
      store: Store(initialState: FilmsList.State()) {
        FilmsList()
      }
    )
  }
}

fileprivate struct FilmCardView: View {
  let film: Film
  
  var body: some View {
    HStack(alignment: .top) {
      FilmImageView(urlPath: film.imageURL.absoluteString)
        .frame(width: 100, height: 150)
      
      VStack(alignment: .leading) {
        HStack {
          Text(film.title)
            .bold()
          
          Spacer()
//          FavoriteButton(filmID: film.id,
//                         favoritesViewModel: favoritesViewModel)
          .buttonStyle(.plain)
          .controlSize(.large)
        }
        .padding(.bottom, 5)
        
        Text("Directed by \(film.director)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text("Released: \(film.releaseDate)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.top)
    }
  }
}


extension SharedReaderKey where Self == InMemoryKey<IdentifiedArrayOf<Film>> {
  static var films: Self {
    inMemory("films")
  }
}
