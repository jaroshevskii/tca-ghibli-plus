//
//  DefaultGhibliService.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

struct DefaultGhibliService: GhibliService {
    
    func fetch<T: Decodable>(from URLString: String, type: T.Type,) async throws -> T {
        guard let url = URL(string: URLString) else {
            throw APIError.invalideURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
           return try JSONDecoder().decode(type, from: data)
        } catch let error as DecodingError {
            throw APIError.decoding(error)
        } catch let error as URLError {
            throw APIError.networkError(error)
        }
    }
    
    func fetchFilms() async throws -> [LegacyFilm] {
        let url = "https://ghibliapi.vercel.app/films"
        return try await fetch(from: url, type: [LegacyFilm].self)
    }
    
    
    func searchFilm(for searchTerm: String) async throws -> [LegacyFilm] {
        let allFilms = try await fetchFilms() //dont have a search endpoint otherwise would do this here
        
        return allFilms.filter { film in
            film.title.localizedStandardContains(searchTerm)
        }
    }
    
    func fetchPerson(from URLString: String) async throws -> Person {
        return try await fetch(from: URLString, type: Person.self)
    }
}
