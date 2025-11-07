//
//  SearchView.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/7/25.
//

import SwiftUI

struct SearchView: View {
  @State private var text = ""
  
  var body: some View {
    NavigationStack {
      Text("Hello, World!")
        .searchable(text: $text)
    }
  }
}

#Preview {
  SearchView()
}
