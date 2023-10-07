//
//  PlayedSong.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import CoreData

extension PlayedSong {
    
    static func save(coreDataStack: CoreDataStack,
                     songID: Int, songName: String, songURL: String,
                     albumID: Int, albumCover: String, albumName: String) {
        
        let playedSong = PlayedSong(context: coreDataStack.persistentContainer.viewContext)
        
        playedSong.createdDate = Date()
        
        playedSong.songID = songID.int64
        playedSong.songName = songName
        playedSong.songURL = songURL
 
        playedSong.albumID = albumID.int64
        playedSong.albumCover = albumCover
        playedSong.albumName = albumName
        
        coreDataStack.saveContext()
    }
    
}
