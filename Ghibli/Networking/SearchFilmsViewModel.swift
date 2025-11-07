//
//  SearchFilmsViewModel.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/7/25.
//

import Foundation
import Observation

@Observable
final class SearchFilmsViewModel {
  var state = LoadingState<[Film]>.idle
  
  var films: [Film] = []
  
  private let service: GhibliService
  
  init(service: GhibliService = DefaultGhibliService()) {
    self.service = service
  }
  
  func fetch(for searchTerm: String) async {
    try? await Task.sleep(for: .milliseconds(300))
    guard !Task.isCancelled else { return }
    
    guard !searchTerm.isEmpty else { return }
    
    state = .loading
    do {
      state = .success(try await service.searchFilms(query: searchTerm))
    } catch let error as APIError {
      state = .error(error.errorDescription ?? "Unknown error")
    } catch {
      state = .error("Unknown error")
    }
  }
}
