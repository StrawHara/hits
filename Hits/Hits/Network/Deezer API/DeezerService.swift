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
}

final class DeezerService: DeezerServiceProtocol {
    let apiClient = URLSessionAPIClient<UserEndpoint>()
    
    func getHitsArtists(hitID: Int) -> AnyPublisher<[Artist], Error> {
        return apiClient.requestPageContent(.getHitsArtists(hitID: hitID))
    }
}
