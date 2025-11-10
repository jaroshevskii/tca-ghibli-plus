//
//  GhibliApp.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/9/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct GhibliApp: App {
  static let store = Store(initialState: Films.State()) {
    Films()
  }
  
  var body: some Scene {
    WindowGroup {
      FilmsView(store: Self.store)
    }
  }
}
