//
//  GhibliClient.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/9/25.
//

import ComposableArchitecture

@DependencyClient
struct GhibliClient {
  var films: @Sendable () async throws -> IdentifiedArrayOf<Film>
}

extension GhibliClient: TestDependencyKey {
  static let previewValue = Self(
    films: { Film.mocks }
  )
  
  static let testValue = Self()
}

extension DependencyValues {
  var ghibli: GhibliClient {
    get { self[GhibliClient.self] }
    set { self[GhibliClient.self] = newValue }
  }
}
