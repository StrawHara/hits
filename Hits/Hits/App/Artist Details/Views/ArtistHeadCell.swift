//
//  ArtistHeadCell.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import UIKit
import Combine

protocol ArtistHeadCellDelegate: AnyObject {
    func playOrderedSongs()
    func playShuffledSongs()
}

final class ArtistHeadCell: UITableViewCell {
    
    static let identifier = "ArtistHeadCell"
    
    @IBOutlet weak var artistCoverImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!

    private var artist: Artist?
    private var delegate: ArtistHeadCellDelegate?
    // play
    // add to favs

    private var cancellable: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setupCell()
    }
    
    // MARK: Public
    func setup(artist: Artist, delegate: ArtistHeadCellDelegate) {
        self.artist = artist
        self.delegate = delegate
        
        self.setupCell()
    }
    
    // MARK: Privates
    private func setupCell() {
        guard let artist = self.artist else {return}
        
        self.playButton.layer.cornerRadius = 10
        self.shuffleButton.layer.cornerRadius = 10
        
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
        self.delegate?.playOrderedSongs()
    }
    
    @IBAction func shuffleButtonDidTouchedUp(_ sender: Any) {
        self.delegate?.playShuffledSongs()
    }
    

}

