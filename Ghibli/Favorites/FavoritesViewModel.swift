//
//  FavoritesViewModel.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/7/25.
//

import Foundation
import Observation

@Observable
final class FavoritesViewModel {
  private(set) var favoritesIDs = Set<String>()
  
  private let service: FavoriteStorage
  
  init(service: FavoriteStorage = DefaultFavoriteStorage()) {
    self.service = service
  }

  func load() {
    favoritesIDs = service.load()
  }
  
  func save() {
    service.save(favoriteIDs: favoritesIDs)
  }
  
  func toggleFavorite(filmID: String) {
    if favoritesIDs.contains(filmID) {
      favoritesIDs.remove(filmID)
    } else {
      favoritesIDs.insert(filmID)
    }
    
    service.save(favoriteIDs: favoritesIDs)
  }
  
  func isFavorite(filmID: String) -> Bool {
    favoritesIDs.contains(filmID)
  }
}
