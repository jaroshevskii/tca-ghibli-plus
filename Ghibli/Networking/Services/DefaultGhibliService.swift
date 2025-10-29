//
//  DefaultGhibliService.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

struct DefaultGhibliService: GhibliService {
  func fetchPerson(from urlString: String) async throws -> Person {
    try await fetch(form: "https://ghibliapi.vercel.app/people/986faac6-67e3-4fb8-a9ee-bad077c2e7fe", type: Person.self)
  }
  
  func fetchFilms() async throws -> [Film] {
    try await fetch(form: "https://ghibliapi.vercel.app/films", type: [Film].self)
  }
  
  private func fetch<T: Decodable>(form urlString: String, type: T.Type) async throws -> T {
    let url = URL(string: urlString)!
    let (data, response) = try await URLSession.shared.data(from: url)

    if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
      throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(type, from: data)
  }
}
