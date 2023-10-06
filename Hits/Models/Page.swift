//
//  Page.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

struct Page<T: Decodable>: Decodable {

    let count: Int
    let page: Int
    var data: T?

    enum CodingKeys: String, CodingKey {
        case count = "total"
        case page, data
    }
        
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 0
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
