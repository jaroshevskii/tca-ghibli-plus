//
//  APIError.swift
//  Ghibli
//
//  Created by Sasha Jaroshevskii on 10/29/25.
//

import Foundation

enum APIError: LocalizedError {
  case invalidURL, invalidResponse, decoding(Error), network(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidURL: "The URL is invalid"
    case .invalidResponse: "Invalid response from server"
    case .decoding(let error): "Failed to decode response: \(error.localizedDescription)"
    case .network(let error): "Network error: \(error.localizedDescription)"
    }
  }
}
