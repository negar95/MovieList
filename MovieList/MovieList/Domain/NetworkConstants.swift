//
//  NetworkConstants.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 6/7/25.
//

import Network
import Foundation

enum NetworkConstants {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/original"
    static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNTA5OTU3YzkyZThiNWQ1ODMxZTllYTI4YjI4Njc2NiIsInN1YiI6IjY2MmZjN2IxNjlkMjgwMDEyMzQzOTBkZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WIoztE5UxssrXbstmj4lf-cJ3hiHfN765_B5pebQemE"
    static let bearerToken: String = "Bearer \(token)"
}


extension RequestProtocol {
    var baseURL: String { NetworkConstants.baseUrl }
    var timeoutInterval: TimeInterval { 30.0 }
    var retryDelay: UInt64 { 1_000_000_000 }
}
