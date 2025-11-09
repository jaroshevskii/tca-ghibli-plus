//
//  File.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/6/25.
//

import Foundation


protocol GhibliService {
    func fetchFilms() async throws -> [LegacyFilm]
    func fetchPerson(from URLString: String) async throws -> Person
    
    func searchFilm(for searchTerm: String) async throws -> [LegacyFilm]
}
