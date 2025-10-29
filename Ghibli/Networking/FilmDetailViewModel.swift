//
//  FilmDetailViewModel.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation
import Observation
import Playgrounds

final class FilmDetailViewModel {
  var people: [Person] = []
  
  private let service: GhibliService
  
  init(service: GhibliService = DefaultGhibliService()) {
    self.service = service
  }
  
  func fetch(for film: Film) async {
    do {
      try await withThrowingTaskGroup(of: Person.self) { group in
        for personInfoURL in film.people {
          group.addTask {
            print("start fetch for \(personInfoURL)")
            let person = try await self.service.fetchPerson(from: personInfoURL)
            print("finished fetch for \(personInfoURL)")
            return person
          }
        }
        for try await person in group {
          people.append(person)
        }
      }
    } catch {
      
    }
  }
}

#Playground {
  let vm = FilmDetailViewModel()
  let film = MockGhibliService().fetchFilm()
  await vm.fetch(for: film)
}
