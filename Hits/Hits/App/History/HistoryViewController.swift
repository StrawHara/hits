//
//  HistoryViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import CoreData

final class HistoryViewController: UIViewController, StoryboardBased {

    private var coreDataStack: CoreDataStack?
    private var audioManager: AudioManager?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var playedSongs: [PlayedSong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "History"
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchPlayedSongs()
    }
    
    func setup(coreDataStack: CoreDataStack, audioManager: AudioManager) {
        self.coreDataStack = coreDataStack
        self.audioManager = audioManager
    }
    
    // MARK: Privates
    private func fetchPlayedSongs() {
        guard let coreDataStack = self.coreDataStack else {return}
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayedSong")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(PlayedSong.createdDate), ascending: false)]
        self.playedSongs = (try? coreDataStack.persistentContainer.viewContext.fetch(request) as? [PlayedSong]) ?? []
         
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorColor = .clear
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: SongCell.identifier, bundle: nil),
                                forCellReuseIdentifier: SongCell.identifier)

        self.tableView.reloadData()
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playedSong = self.playedSongs[safe: indexPath.row],
              let album = Album(id: Int(playedSong.albumID), title: playedSong.albumName, cover: playedSong.albumCover),
              let song = Song(id: Int(playedSong.songID), title: playedSong.songName, preview: playedSong.songURL,
                                  album: album)
        else {return}
        
        self.audioManager?.play(song: song)
        self.fetchPlayedSongs()
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        guard let playedSong = self.playedSongs[safe: indexPath.row],
              let album = Album(id: Int(playedSong.albumID), title: playedSong.albumName, cover: playedSong.albumCover),
              let song = Song(id: Int(playedSong.songID), title: playedSong.songName, preview: playedSong.songURL,
                                        album: album),
              let songCell = self.tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as? SongCell else {
            return cell
        }

        songCell.setup(song: song)
        cell = songCell

        return cell
    }
    
}
