//
//  DeezerEndpoint.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

enum DeezerEndpoint: APIEndpoint {
    
    case getHitsArtists(hitID: Int)
    case getArtist(artistID: Int)
    case getArtistTopSongs(artistID: Int)

    var baseURL: URL {
        return URL(string: "https://api.deezer.com/")!
    }
    
    var path: String {
        switch self {
        case .getHitsArtists(let id):
            return "chart/\(id)/artists"
        case .getArtist(let artistID):
            return "artist/\(artistID)"
        case .getArtistTopSongs(let artistID):
            return "artist/\(artistID)/top"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHitsArtists, .getArtist, .getArtistTopSongs:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default: [:]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getHitsArtists, .getArtistTopSongs:
            return ["page": 1, "limit": 10]
        default:
            return [:]
        }
    }
}
