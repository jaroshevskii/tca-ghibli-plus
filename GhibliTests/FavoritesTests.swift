//
//  FavoritesTests.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/10/25.
//

import Testing
import ComposableArchitecture
import Tagged
@testable import Ghibli

@MainActor
struct FavoritesTests {
//  @Test("Toggle favorite adds ID when not present")
//  func toggleAddsID() async {
//    let store = TestStore(initialState: Favorites.State()) {
//      Favorites()
//    }
//    
//    let filmID = Film.ID()
//    await store.send(.toggleFavorite(filmID)) {
//      $0.favorites.insert(filmID)
//    }
//  }
  
//  @Test("Toggle favorite removes ID when present")
//  func toggleRemovesID() async {
//    let filmID = Film.ID()
//    
//    let store = TestStore(
//      initialState: Favorites.State()
//    ) {
//      Favorites()
//    } withDependencies: {
//      $0[SharedKey<Set<Film.ID>>.favoritesIDs] = [filmID]
//    }
//    
//    await store.send(.toggleFavorite(filmID)) {
//      $0.favorites.remove(filmID)
//    }
//    
//    #expect(!store.state.favorites.contains(filmID))
//  }
  
//  @Test("Toggle favorite multiple times")
//  func toggleMultipleTimes() async {
//    let store = TestStore(initialState: Favorites.State()) {
//      Favorites()
//    }
//    
//    let filmID = Film.ID()
//    
//    // Add
//    await store.send(.toggleFavorite(filmID)) {
//      $0.favorites.insert(filmID)
//    }
//    
//    // Remove
//    await store.send(.toggleFavorite(filmID)) {
//      $0.favorites.remove(filmID)
//    }
//    
//    // Add again
//    await store.send(.toggleFavorite(filmID)) {
//      $0.favorites.insert(filmID)
//    }
//    
//    #expect(store.state.favorites.contains(filmID))
//  }
  
//  @Test("Toggle different film IDs")
//  func toggleDifferentIDs() async {
//    let store = TestStore(initialState: Favorites.State()) {
//      Favorites()
//    }
//    
//    let filmID1 = Film.ID()
//    let filmID2 = Film.ID()
//    let filmID3 = Film.ID()
//    
//    await store.send(.toggleFavorite(filmID1)) {
//      $0.favorites.insert(filmID1)
//    }
//    
//    await store.send(.toggleFavorite(filmID2)) {
//      $0.favorites.insert(filmID2)
//    }
//    
//    await store.send(.toggleFavorite(filmID3)) {
//      $0.favorites.insert(filmID3)
//    }
//    
//    #expect(store.state.favorites.count == 3)
//    #expect(store.state.favorites.contains(filmID1))
//    #expect(store.state.favorites.contains(filmID2))
//    #expect(store.state.favorites.contains(filmID3))
//  }
  
//  @Test("Toggle removes only specified ID")
//  func toggleRemovesOnlySpecifiedID() async {
//    let filmID1 = Film.ID()
//    let filmID2 = Film.ID()
//    
//    let store = TestStore(
//      initialState: Favorites.State()
//    ) {
//      Favorites()
//    } withDependencies: {
//      $0[SharedKey<Set<Film.ID>>.favoritesIDs] = [filmID1, filmID2]
//    }
//    
//    await store.send(.toggleFavorite(filmID1)) {
//      $0.favorites.remove(filmID1)
//    }
//    
//    #expect(!store.state.favorites.contains(filmID1))
//    #expect(store.state.favorites.contains(filmID2))
//    #expect(store.state.favorites.count == 1)
//  }
  
//  @Test("Empty favorites set initially")
//  func emptyInitially() async {
//    let store = TestStore(initialState: Favorites.State()) {
//      Favorites()
//    }
//    
//    #expect(store.state.favorites.isEmpty)
//  }
}
