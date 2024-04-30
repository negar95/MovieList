//
//  MovieRequest.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 4/29/24.
//

import Foundation

enum MovieRequest {
    case search(query: String, page: Int)
    case list(page: Int)
}

extension MovieRequest: RequestProtocol {
    var path: String {
        switch self {
        case .search:
            return "/search/movie"
        case .list:
            return "/discover/movie"
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case let .search(query, page):
            return [
                "query": query,
                "page": page
            ]
        case let .list(page):
            return [
                "page": page
            ]
        }
    }

}
