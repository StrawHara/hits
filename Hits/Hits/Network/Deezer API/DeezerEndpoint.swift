//
//  DeezerEndpoint.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

enum UserEndpoint: APIEndpoint {
    
    case getHitsArtists(hitID: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.deezer.com/")!
    }
    
    var path: String {
        switch self {
        case .getHitsArtists(let id):
            return "chart/\(id)/artists"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHitsArtists:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getHitsArtists:
            return ["Authorization": "Bearer TOKEN"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getHitsArtists:
            return ["page": 1, "limit": 10]
        }
    }
}
