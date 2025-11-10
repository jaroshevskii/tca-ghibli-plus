//
//  FilmsList.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/9/25.
//

import ComposableArchitecture
import SwiftUI
import NukeUI

@Reducer
struct FilmsList {
  @ObservableState
  struct State: Equatable {
    @Shared(.films) var films: IdentifiedArrayOf<Film>
    var loading = LoadingState.idle
    var favorites = Favorites.State()
    
    enum LoadingState: Equatable {
      case idle, loading, loaded, failed(String)
    }
  }
  
  enum Action {
    case task
    case filmsResponse(Result<IdentifiedArrayOf<Film>, any Error>)
    case favoriteButtonTapped(Film.ID)
    case retryLoadButtonTapped
    case favorites(Favorites.Action)
  }
  
  @Dependency(\.ghibli) var ghibli
  
  var body: some ReducerOf<Self> {
    Scope(state: \.favorites, action: \.favorites) {
      Favorites()
    }
    Reduce { state, action in
      switch action {
      case .task:
        guard case .idle = state.loading else { return .none }
        return loadFilms(state: &state)
      
      case .retryLoadButtonTapped:
        return loadFilms(state: &state)
        
      case let .filmsResponse(.success(films)):
        state.loading = .loaded
        state.$films.withLock { $0 = films }
        return .none
      
      case let .filmsResponse(.failure(error)):
        state.loading = .failed(error.localizedDescription)
        return .none
        
      case .favorites:
        return .none
        
      case let .favoriteButtonTapped(filmID):
        return .send(.favorites(.toggle(filmID)))
      }
    }
  }
  
  private func loadFilms(state: inout State) -> Effect<Action> {
    state.loading = .loading
    return .run { send in
      await send(.filmsResponse(Result { try await ghibli.films() }))
    }
  }
}

extension SharedReaderKey where Self == InMemoryKey<IdentifiedArrayOf<Film>>.Default {
  static var films: Self {
    Self[.inMemory("Films"), default: []]
  }
}

struct FilmsListView: View {
  let store: StoreOf<FilmsList>

  var body: some View {
    List {
      switch store.loading {
      case .idle, .loading:
        placeholderCards
      case .loaded:
        filmCards
      case .failed:
        EmptyView()
      }
    }
    .animation(.smooth, value: store.loading)
    .overlay {
      if case .failed(let message) = store.loading {
        failedView(message: message)
      }
    }
    .navigationTitle("Ghibli Films")
    .task { await store.send(.task).finish() }
  }
  
  private var placeholderCards: some View {
    ForEach(0..<5, id: \.self) { _ in
      NavigationLink(destination: EmptyView()) {
        FilmCardView(film: .placeholder)
      }
      .redacted(reason: .placeholder)
      .disabled(true)
    }
  }
  
  private var filmCards: some View {
    ForEach(store.films) { film in
      NavigationLink(state: Films.Path.State.detail(FilmDetail.State(film: film))) {
        FilmCardView(
          film: film,
          isFavorite: store.favorites.ids.contains(film.id),
          favoriteButtonAction: { store.send(.favoriteButtonTapped(film.id)) }
        )
      }
    }
  }
  
  private func failedView(message: String) -> some View {
    ContentUnavailableView {
      Label("Failed to Load", systemImage: "exclamationmark.triangle")
    } description: {
      Text(message)
    } actions: {
      Button("Retry") { store.send(.retryLoadButtonTapped) }
    }
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

#Preview("Loading") {
  NavigationStack {
    FilmsListView(
      store: Store(initialState: FilmsList.State(loading: .loading)) {
        FilmsList()
      }
    )
  }
}

#Preview("Error") {
  NavigationStack {
    FilmsListView(
      store: Store(
        initialState: FilmsList.State(loading: .failed("Network connection failed"))
      ) {
        FilmsList()
      }
    )
  }
}

fileprivate struct FilmCardView: View {
  private let film: Film
  private let isFavorite: Bool
  private let favoriteButtonAction: (() -> Void)?
  
  init(
    film: Film,
    isFavorite: Bool = false,
    favoriteButtonAction: (() -> Void)? = nil
  ) {
    self.film = film
    self.isFavorite = isFavorite
    self.favoriteButtonAction = favoriteButtonAction
  }
  
  var body: some View {
    HStack(alignment: .top) {
      FilmImageView(url: film.imageURL) { image in
        image.resizable()
      }
      .frame(width: 100, height: 150)

      VStack(alignment: .leading) {
        HStack {
          Text(film.title)
            .bold()
          
          Spacer()
          
          Button {
            favoriteButtonAction?()
          } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
              .foregroundStyle(isFavorite ? .pink : .gray)
          }
          .buttonStyle(.plain)
        }
        .padding(.bottom, 4)
        
        Text("Directed by \(film.director)")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        Text("Released in \(film.releaseDate)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.vertical)
    }
  }
}

struct FilmImageView<Content: View>: View {
  let imageURL: URL?
  let content: (Image) -> Content
  
  init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content) {
    self.imageURL = url
    self.content = content
  }
  
  var body: some View {
    LazyImage(url: imageURL, transaction: Transaction(animation: .default)) { state in
      if let image = state.image {
        content(image)
      } else {
        Color.gray.opacity(0.25)
      }
    }
  }
}
