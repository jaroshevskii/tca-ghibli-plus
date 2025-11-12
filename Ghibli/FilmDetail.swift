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
    
      VStack(alignment: .leading) {
        Text(store.film.title)
          .font(.title.bold())
        
        detailsGrid
          .padding(.vertical, 8)
        
        Divider()
        
        descriptionSection
      }
      .padding()
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
    ParallaxHeaderView(height: 300) {
      FilmImageView(url: store.film.bannerImageURL) { image in
        image.resizable().scaledToFill()
      }
    }
  }
  
  var detailsGrid: some View {
    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
      DetailRow(label: "Director", value: store.film.director)
      DetailRow(label: "Producer", value: store.film.producer)
      DetailRow(label: "Release Date", value: store.film.releaseDate)
      DetailRow(label: "Running Time", value: "\(store.film.duration) minutes")
      DetailRow(label: "Score", value: "\(store.film.ratingScore)/100")
    }
  }
  
  var descriptionSection: some View {
    Group {
      Text("Description")
        .font(.headline)
      Text(store.film.description)
    }
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

fileprivate struct ParallaxHeaderView<Content: View>: View {
  let height: CGFloat
  let content: () -> Content
  
  init(
    height: Double,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.height = height
    self.content = content
  }
  
  var body: some View {
    GeometryReader { proxy in
      let offset = proxy.frame(in: .global).minY
      let calculatedHeight = max(proxy.size.height + offset, 0)
      
      content()
        .frame(width: proxy.size.width, height: calculatedHeight)
        .offset(y: -offset)
    }
    .clipShape(BottomClipShape())
    .frame(height: height)
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

fileprivate struct DetailRow: View {
  let label: LocalizedStringKey
  let value: String

  var body: some View {
    GridRow {
      Text(label)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      Text(value)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
