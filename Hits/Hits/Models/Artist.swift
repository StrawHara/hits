//
//  Artist.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

// MARK: Decodable
struct Artist: Decodable, Identifiable {
    
    let id: Int
    let name: String

    let link: String
    let position: Int
 
    let picture: String
    let pictureS: String
    let pictureM: String
    let pictureB: String
    let pictureXL: String

   
    enum CodingKeys: String, CodingKey {
        case id, name, link, position

        case picture = "picture"
        case pictureS = "picture_small"
        case pictureM = "picture_medium"
        case pictureB = "picture_big"
        case pictureXL = "picture_xl"
    }
    
    init(id: Int, name: String, link: String, postion: Int,
         picture: String, pictureS: String, pictureM: String, pictureB: String, pictureXL: String) {
        self.id = id
        self.name = name
        self.link = link
        self.position = postion
        
        self.picture = picture
        self.pictureS = pictureS
        self.pictureM = pictureM
        self.pictureB = pictureB
        self.pictureXL = pictureXL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.link = try container.decode(String.self, forKey: .link)
        self.position = try container.decode(Int.self, forKey: .position)
        
        self.picture = try container.decode(String.self, forKey: .picture)
        self.pictureS = try container.decode(String.self, forKey: .pictureS)
        self.pictureM = try container.decode(String.self, forKey: .pictureM)
        self.pictureB = try container.decode(String.self, forKey: .pictureB)
        self.pictureXL = try container.decode(String.self, forKey: .pictureXL)
    }
    
}

// MARK: DATA Sample
// {"id":1519461,"name":"PNL","link":"https:\/\/www.deezer.com\/artist\/1519461","picture":"https:\/\/api.deezer.com\/artist\/1519461\/image","picture_small":"https:\/\/e-cdns-images.dzcdn.net\/images\/artist\/9277fdce45b79945918c24f69cb6e8e3\/56x56-000000-80-0-0.jpg","picture_medium":"https:\/\/e-cdns-images.dzcdn.net\/images\/artist\/9277fdce45b79945918c24f69cb6e8e3\/250x250-000000-80-0-0.jpg","picture_big":"https:\/\/e-cdns-images.dzcdn.net\/images\/artist\/9277fdce45b79945918c24f69cb6e8e3\/500x500-000000-80-0-0.jpg","picture_xl":"https:\/\/e-cdns-images.dzcdn.net\/images\/artist\/9277fdce45b79945918c24f69cb6e8e3\/1000x1000-000000-80-0-0.jpg","radio":true,"tracklist":"https:\/\/api.deezer.com\/artist\/1519461\/top?limit=50","position":10,"type":"artist"}
