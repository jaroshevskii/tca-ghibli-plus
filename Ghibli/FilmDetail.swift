//
//  FilmDetail.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/10/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct FilmDetail {
  @ObservableState
  struct State: Equatable {
    let film: Film
    var favorites = Favorites.State()
    
    var isFavorite: Bool {
      favorites.ids.contains(film.id)
    }
  }
  
  enum Action {
    case task
    case favorites(Favorites.Action)
    case favoriteButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.favorites, action: \.favorites) {
      Favorites()
    }
    Reduce { state, action in
      switch action {
      case .task:
        return .none
      
      case .favorites:
        return .none
        
      case .favoriteButtonTapped:
        return .send(.favorites(.toggle(state.film.id)))
      }
    }
  }
}

struct FilmDetailView: View {
  let store: StoreOf<FilmDetail>
  
  var body: some View {
    ScrollView {
      headerView
    
      Text("hello")
        .background {
          Color.red
        }
    }
    .scrollEdgeEffectHidden(true, for: .top)
    .ignoresSafeArea(edges: .top)
    .toolbar {
      Button {
        store.send(.favoriteButtonTapped)
      } label: {
        Image(systemName: store.isFavorite ? "heart.fill" : "heart")
          .foregroundStyle(store.isFavorite ? .pink : .gray)
      }
      .buttonStyle(.plain)
    }
  }
  
  var headerView: some View {
    GeometryReader { proxy in
      let minY = proxy.frame(in: .global).minY
      FilmImageView(url: store.film.bannerImageURL) { image in
        image.resizable().scaledToFill()
      }
      .frame(width: proxy.size.width, height: max(proxy.size.height + minY, 0))
      .offset(y: -minY)
    }
    .clipShape(BottomClipShape())
    .frame(height: 300)
  }
}

#Preview {
  NavigationStack {
    FilmDetailView(
      store: Store(initialState: FilmDetail.State(film: .mock)) {
        FilmDetail()
      }
    )
  }
}

fileprivate struct BottomClipShape: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.minX, y: rect.minY - rect.height * 2))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY - rect.height * 2))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.closeSubpath()
    }
  }
}
