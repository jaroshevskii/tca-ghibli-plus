//
//  GhibliTests.swift
//  GhibliTests
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Testing
@testable import Ghibli


// TODO: Add more tests
struct GhibliTests {
  @MainActor
  @Test func testInitialState() async throws {
    let service = MockGhibliService()
    let viewModel = SearchFilmsViewModel(service: service)
    
    #expect(viewModel.state.data?.isEmpty == true)
    
    if case .idle = viewModel.state {
      
    } else {
      Issue.record("Expected idle state")
    }
  }
  
  @MainActor
  @Test("Search with query filters results")
  func testFetchFilms() async throws {
    let service = MockGhibliService()
    let viewModel = SearchFilmsViewModel(service: service)
    
    await viewModel.fetch(for: "Castle in the Sky")
    
    #expect(viewModel.state.data?.count == 1)
    #expect(viewModel.state.data?.first?.title == "Castle in the Sky")
  }
}
