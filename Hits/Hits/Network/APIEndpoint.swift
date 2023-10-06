//
//  APIEndpoint.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}
