//
//  HistoryViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import CoreData

final class HistoryViewController: UITableViewController, StoryboardBased, NSFetchedResultsControllerDelegate {

    private var coreDataStack: CoreDataStack?
    private var audioManager: AudioManager?
    
    var fetchedResultsController: NSFetchedResultsController<PlayedSong>?
        
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
    
        if fetchedResultsController == nil {
            let request = PlayedSong.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(PlayedSong.createdDate), ascending: false)]

            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController?.delegate = self
        }

        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
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
    
    // MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playedSong = self.fetchedResultsController?.object(at: indexPath),
              let album = Album(id: Int(playedSong.albumID), title: playedSong.albumName, cover: playedSong.albumCover),
              let song = Song(id: Int(playedSong.songID), title: playedSong.songName, preview: playedSong.songURL,
                                  album: album)
        else {return}
        
        self.audioManager?.play(song: song)
    }
    
    // MARK: Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController?.sections![section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard let playedSong = self.fetchedResultsController?.object(at: indexPath),
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
    

    // MARK: Datasource updates
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let playedSong = self.fetchedResultsController?.object(at: indexPath) {
            self.coreDataStack?.persistentContainer.viewContext.delete(playedSong)
            self.coreDataStack?.saveContext()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        default:
            break
        }
    }
}
