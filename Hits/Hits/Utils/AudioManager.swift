//
//  AudioManager.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import AVFoundation

final class AudioManager: NSObject {
    
    private var audioPlayer: AVPlayer?
    private var coreDataStack: CoreDataStack?
    
    var isPlaying: Bool { (audioPlayer?.rate != 0) && (audioPlayer?.error == nil) }
    
    private(set) var playing: Song?
    private(set) var playingQueue: [Song] = []

    // MARK: init
    func setup(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func play(song: Song) {
        self.playing = song
        
        guard let url = URL(string: song.preview) else {return}
        // TODO: Show error popup message to user
        
        self.audioPlayer = AVPlayer(url: url)
//        self.audioPlayer?.delegate = self
        self.audioPlayer?.play()
        
        self.savePlayedSong(song: song)
    }

    func play() {
        self.audioPlayer?.play()
    }

    func pause() {
        self.audioPlayer?.pause()
    }
    
    func stop() {
        self.audioPlayer?.pause()
        self.audioPlayer = nil
    }

    func next() {
        self.stop()
        if let song = self.playingQueue.first {
            self.playingQueue.removeFirst()
            self.play(song: song)
        }
    }

    func addToPlayingQueue(song: Song) {
        if self.playing == nil {
            self.play(song: song)
        } else {
            self.playingQueue.append(song)
        }
    }

    func addToPlayingQueue(songs: [Song]) {
        var toAddSongs = songs
        if let song = toAddSongs.first {
            self.addToPlayingQueue(song: song)
            toAddSongs.removeFirst()
            self.playingQueue.append(contentsOf: toAddSongs)
        }
    }
    
    private func savePlayedSong(song: Song) {
        guard let coreDataStack = self.coreDataStack else {return}
        
        PlayedSong.save(coreDataStack: coreDataStack,
                        songID: song.id, songName: song.title, songURL: song.preview,
                        albumID: song.album.id, albumCover: song.album.cover, albumName: song.album.title)

    }

}

// TODO: -> AVPlayer delegate
// Compromised -- AVPlayer is not AVAudio and AVAudioPlayer cannot play remote url
// Also it does not seems that AVPlayer got any delegate...
extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playing = nil
        
        if let song = self.playingQueue.first {
            _ = self.playingQueue.removeFirst()
            self.play(song: song)
        }
    }
}
