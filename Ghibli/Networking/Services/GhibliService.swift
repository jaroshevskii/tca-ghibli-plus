//
//  GhibliService.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

protocol GhibliService: Sendable {
  func fetchFilms() async throws -> [Film]
  func fetchPerson(from urlString: String) async throws -> Person 
}
