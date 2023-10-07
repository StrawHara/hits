//
//  ArtistDetailsViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import Combine

final class ArtistDetailsViewController: UIViewController, StoryboardBased {
    
    // MARK: IBOutlets
    @IBOutlet weak var artistCoverImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ArtistDetailsViewModel?
    private var delegate: ArtistDetailsCoordinatorDelegate?

    private var cancellable: AnyCancellable?

    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Public
    func setup(viewModel: ArtistDetailsViewModel?, delegate: ArtistDetailsCoordinatorDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        self.refresh()
    }
    
    func refresh() {
        guard let viewModel = self.viewModel,
            let artist = viewModel.artist else {return}

        self.artistNameLabel.text = artist.name
        self.cancellable = self.loadImage(for: artist.pictureM).sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        self.artistCoverImage.image = image
        self.artistCoverImage.clipsToBounds = true
        self.artistCoverImage.layer.cornerRadius = 20
    }
    
    private func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
        .flatMap({ url -> AnyPublisher<UIImage?, Never> in
            let url = URL(string: url)!
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }
    
    // MARK: IBActions
    @IBAction func playButtonDidTouchedUp(_ sender: Any) {
        guard let song = self.viewModel?.songs.first else {return}
        self.delegate?.playSong(song: song)
    }
    
    @IBAction func shuffleButtonDidTouchedUp(_ sender: Any) {
        guard var songs = self.viewModel?.songs else {return}
        let random = songs.shuffled()
        self.delegate?.addToPlayList(songs: random)
    }
    
}
