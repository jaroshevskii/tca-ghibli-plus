//
//  LoadingState.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 11/7/25.
//

import Foundation

enum LoadingState<T> {
  case idle
  case loading
  case success(T)
  case error(String)
  
  var isLoading: Bool {
    switch self {
    case .loading: true
    default: false
    }
  }
  
  var data: T? {
    if case .success(let data) = self {
      data
    } else {
      nil
    }
  }
  
  var error: String? {
    if case .error(let error) = self {
      error
    } else {
      nil
    }
  }
}
