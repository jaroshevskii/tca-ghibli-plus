//
//  DefaultGhibliService.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

struct DefaultGhibliService: GhibliService {
  func fetchPerson(from urlString: String) async throws -> Person {
    try await fetch(from: urlString, type: Person.self)
  }
  
  func fetchFilms() async throws -> [Film] {
    try await fetch(from: "https://ghibliapi.vercel.app/films", type: [Film].self)
  }
  
  func searchFilms(query: String) async throws -> [Film] {
    let all = try await fetchFilms()
    let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !q.isEmpty else { return all }
    return all.filter { film in
      film.title.lowercased().contains(q) ||
      film.description.lowercased().contains(q)
    }
  }
  
  private func fetch<T: Decodable>(from urlString: String, type: T.Type) async throws -> T {
    guard let url = URL(string: urlString) else { throw APIError.invalidURL }
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
        throw APIError.invalidResponse
      }
      return try JSONDecoder().decode(type, from: data)
    } catch let error as DecodingError {
      throw APIError.decoding(error)
    } catch {
      throw APIError.network(error)
    }
  }
}
