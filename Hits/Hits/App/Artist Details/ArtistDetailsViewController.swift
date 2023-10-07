//
//  ArtistDetailsViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import Combine

final class ArtistDetailsViewController: UIViewController, StoryboardBased {
    
    enum Section: Int {
        case head = 0
        case songs
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ArtistDetailsViewModel?
    private var delegate: ArtistDetailsCoordinatorDelegate?
    
    private let tableViewSections: [Section] = [.head, .songs]

    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Public
    func setup(viewModel: ArtistDetailsViewModel?, delegate: ArtistDetailsCoordinatorDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    // MARK: Privates
    private func setupTableView() {
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorColor = .clear
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: ArtistHeadCell.identifier, bundle: nil),
                                forCellReuseIdentifier: ArtistHeadCell.identifier)
        self.tableView.register(UINib(nibName: SongCell.identifier, bundle: nil),
                                forCellReuseIdentifier: SongCell.identifier)
        
        self.refresh()
    }
    
    func refresh() {
        guard self.viewModel != nil else {return}
        self.tableView.reloadData()
    }
    
}

extension ArtistDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let song = self.viewModel?.songs[safe: indexPath.row] else {return}
        self.delegate?.playSong(song: song)
    }
}
    
extension ArtistDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {return 0}
        
        switch section {
        case .head: return 1
        case .songs: return self.viewModel?.songs.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard let section = Section(rawValue: indexPath.section) else {return cell}

        switch section {
        case .head:
            guard let artist = self.viewModel?.artist,
                  let headArtistCell = self.tableView.dequeueReusableCell(withIdentifier: ArtistHeadCell.identifier, for: indexPath) as? ArtistHeadCell else {
                return cell
            }
            
            headArtistCell.setup(artist: artist, delegate: self)
            cell = headArtistCell

        case .songs:
            guard let song = self.viewModel?.songs[safe: indexPath.row],
                  let songCell = self.tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as? SongCell else {
                return cell
            }
            
            songCell.setup(song: song)
            // TODO: bind delegate
            cell = songCell
        }

        return cell
    }
    
}

extension ArtistDetailsViewController: ArtistHeadCellDelegate {
    
    func playOrderedSongs() {
        guard let song = self.viewModel?.songs.first else {return}
        self.delegate?.playSong(song: song)
    }
    
    func playShuffledSongs() {
        guard let songs = self.viewModel?.songs else {return}
        let random = songs.shuffled()
        self.delegate?.addToPlayingQueue(songs: random)
    }

}
