//
//  PlayingQueueViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 08/10/2023.
//

import UIKit

class PlayingQueueViewController: UIViewController {
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.safeArea = view.layoutMarginsGuide
        self.setupTableView()
    }
    
    func setup(songs: [Song]) {
        self.songs = songs
    }

    func setupTableView() {
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        self.tableView.dataSource = self
        
        self.tableView.separatorColor = .clear
        self.tableView.rowHeight = UITableView.automaticDimension

        self.tableView.register(UINib(nibName: SongCell.identifier, bundle: nil),
                                forCellReuseIdentifier: SongCell.identifier)
    }
}

extension PlayingQueueViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard let song = self.songs[safe: indexPath.row],
              let songCell = self.tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as? SongCell else {
            return cell
        }
        
        songCell.setup(song: song)
        cell = songCell

        return cell
    }
    
}
