//
//  FilmListView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct FilmListView: View {
  var filmsViewModel = FilmsViewModel()
  
  var body: some View {
    NavigationStack {
      switch filmsViewModel.state {
      case .idle:
        Text("No films yer")
      case .loading:
        ProgressView {
          Text("Loading...")
        }
      case let .loaded(films):
        List(films) { film in
          Text(film.title)
        }
      case let .error(error):
        Text(error)
          .foregroundStyle(.pink)
      }
    }
    .task { await filmsViewModel.fetch() }
  }
}

#Preview {
  @State @Previewable var vm = FilmsViewModel(
    service: MockGhibliService()
  )
  
  FilmListView(filmsViewModel: vm)
}
