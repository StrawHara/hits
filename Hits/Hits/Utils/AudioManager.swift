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
    
    private var playing: Song?
    private var playingQueue: [Song] = []

    // MARK: init
    // TODO: retrieve playList
    
    func play(song: Song) {
        self.playing = song
        
        guard let url = URL(string: song.preview) else {return}
        // TODO: Show error popup message to user
        
        self.audioPlayer = AVPlayer(url: url)
//        self.audioPlayer?.delegate = self
        self.audioPlayer?.play()
    }
    
    func pause() {
        self.audioPlayer?.pause()
        self.audioPlayer = nil
    }
    
    func addToPlayingQueue(song: Song) {
        if self.playing == nil {
            self.play(song: song)
        } else {
            self.playingQueue.append(song)
        }
    }

    func addToPlayingQueue(songs: [Song]) {
        if let song = songs.first {
            self.addToPlayingQueue(song: song)
            _ = songs.dropFirst()
            self.playingQueue.append(contentsOf: songs)
        }
    }

}

// TODO: -> AVPlayer delegate
// Compromised -- AVPlayer is not AVAudio and AVAudioPlayer cannot play remote url
// Also it does not seems that AVPlayer got any delegate...
extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playing = nil
        
        if let song = self.playingQueue.first {
            _ = self.playingQueue.dropFirst()
            self.play(song: song)
        }
    }
}
