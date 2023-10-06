//
//  DeezerService.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation
import Combine

protocol DeezerServiceProtocol {
    func getArtists() -> AnyPublisher<[Artist], Error>
}

final class DeezerService: DeezerServiceProtocol {
    let apiClient = URLSessionAPIClient<UserEndpoint>()
    
    func getArtists() -> AnyPublisher<[Artist], Error> {
        return apiClient.requestPageContent(.getArtists)
    }
}
