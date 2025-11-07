//
//  FilmListView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import SwiftUI

struct FilmListView: View {
  var films: [Film]
  
  var body: some View {
    List(films) { film in
      NavigationLink(value: film) {
        HStack {
          FilmImageView(urlPath: film.image)
            .frame(width: 100, height: 150)
          Text(film.title)
        }
      }
    }
    .navigationDestination(for: Film.self) { film in
      FilmDetailView(film: film)
    }
  }
}

//
//#Preview {
//  @Previewable @State var vm = FilmsViewModel(
//    service: MockGhibliService()
//  )
//  
//  FilmListView(filmsViewModel: vm)
//}
