//
//  FilmsView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/6/25.
//

import SwiftUI

struct FilmsView: View {
  let filmsViewModel: FilmsViewModel
  
  var body: some View {
    NavigationStack {
      Group {
        switch filmsViewModel.state {
        case .idle:
          Text("No films yer")
        case .loading:
          ProgressView {
            Text("Loading...")
          }
        case let .loaded(films):
          FilmListView(films: films)
        case let .error(error):
          Text(error)
            .foregroundStyle(.pink)
        }
      }
      .navigationTitle("Ghibli")
    }
    .task { await filmsViewModel.fetch() }
  }
}

#Preview {
  FilmsView(
    filmsViewModel: FilmsViewModel(
      service: MockGhibliService()
    )
  )
}
