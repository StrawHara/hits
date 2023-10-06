//
//  APIError.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case pageEmpty
    
    var localised: String {
        switch self {
        case .invalidResponse: "Invalid response"
        case .invalidData: "Invalid Data"
        case .pageEmpty: "Page is Empty"
        }
    }
    
    func log() {
        dprint("❌❌❌ Api Error : \(self.localised) ❌❌❌")
    }
}
