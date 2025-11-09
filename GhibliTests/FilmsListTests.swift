//
//  FilmsListTests.swift
//  GhibliTests
//
//  Created by Sasha Jaroshevskii on 11/9/25.
//

import ComposableArchitecture
import Testing
@testable import Ghibli

@MainActor
struct FilmsListTests {
  @Test("Loads films on task")
  func loadsFilms() async {
    let store = TestStore(initialState: FilmsList.State()) {
      FilmsList()
    } withDependencies: {
      $0.ghibli.films = { Film.mocks }
    }
    
    await store.send(.task)
    await store.receive(\.filmsResponse) {
      $0.$films.withLock { $0 = Film.mocks }
    }
  }
}
