//
//  DeezerEndpoint.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

enum UserEndpoint: APIEndpoint {
    
    case getArtists
    
    var baseURL: URL {
        return URL(string: "https://api.deezer.com/")!
    }
    
    var path: String {
        switch self {
        case .getArtists:
            return "chart/0/artists"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getArtists:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getArtists:
            return ["Authorization": "Bearer TOKEN"]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getArtists:
            return ["page": 1, "limit": 10]
        }
    }
}
