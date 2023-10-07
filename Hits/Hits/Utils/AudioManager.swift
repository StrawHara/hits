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
    private var playList: [Song] = []

    // MARK: init
    // TODO: retrieve playList
    
    func play(song: Song) {
        self.playing = song
        
        guard let url = URL(string: song.preview) else {return}
        // TODO: Show error popup message to user
        
        self.audioPlayer = AVPlayer(url: url)
        self.audioPlayer?.play()
    }
    
    func pause() {
        self.audioPlayer?.pause()
        self.audioPlayer = nil
    }
    
    func addToPlaylist(song: Song) {
        if self.playing == nil {
            self.play(song: song)
        } else {
            self.playList.append(song)
        }
    }

    func addToPlaylist(songs: [Song]) {
        if let song = songs.first {
            self.addToPlaylist(song: song)
            _ = songs.dropFirst()
            self.playList.append(contentsOf: songs)
        }
    }

}

extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playing = nil
        
        if let song = self.playList.first {
            _ = self.playList.dropFirst()
            self.play(song: song)
        }
    }
}
