//
//  DeezerService.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import Combine

protocol DeezerServiceProtocol {
    func getHitsArtists(hitID: Int) -> AnyPublisher<[Artist], Error>
    func getArtist(artistID: Int) -> AnyPublisher<Artist, Error>
    func getArtistTopSongs(artistID: Int) -> AnyPublisher<[Song], Error>
}

final class DeezerService: DeezerServiceProtocol {
    let apiClient = URLSessionAPIClient<DeezerEndpoint>()
    
    func getHitsArtists(hitID: Int) -> AnyPublisher<[Artist], Error> {
        return apiClient.requestPageContent(.getHitsArtists(hitID: hitID))
    }
    
    func getArtist(artistID: Int) -> AnyPublisher<Artist, Error> {
        return apiClient.request(.getArtist(artistID: artistID))
    }

    func getArtistTopSongs(artistID: Int) -> AnyPublisher<[Song], Error> {
        return apiClient.requestPageContent(.getArtistTopSongs(artistID: artistID))
    }

}
