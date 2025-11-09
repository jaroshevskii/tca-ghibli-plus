//
//  MockGhibliService.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

struct MockGhibliService: GhibliService {
    
    private struct SampleData: Decodable {
        let films: [LegacyFilm]
        let people: [Person]
    }
    
    private func loadSampleData() throws -> SampleData {
         guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
             throw APIError.invalideURL
         }
         do {
             let data = try Data(contentsOf: url)
             return try JSONDecoder().decode(SampleData.self, from: data)
         } catch let error as DecodingError {
             print(error)
             throw APIError.decoding(error)
         } catch {
             throw APIError.networkError(error)
         }
     }
    
    //MARK: - Protocol conformance
    
    func fetchFilms() async throws -> [LegacyFilm] {
        let data = try loadSampleData()
        return data.films
    }
    
    func searchFilm(for searchTerm: String) async throws -> [LegacyFilm] {
        let allFilms = try await fetchFilms()
        
        return allFilms.filter { film in
            film.title.localizedStandardContains(searchTerm)
        }
    }

    func fetchPerson(from URLString: String) async throws -> Person {
        let data = try loadSampleData()
        return data.people.first!
    }
    
    //MARK: - preview/testing only
    
    func fetchFilm() -> LegacyFilm {
        let data = try! loadSampleData()
        return data.films.first!
    }
}
