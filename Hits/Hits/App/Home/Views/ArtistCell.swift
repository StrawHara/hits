//
//  ArtistCell.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import Combine

final class ArtistCell: UICollectionViewCell {
    
    static let identifier = "ArtistCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistImageWidthConstraint: NSLayoutConstraint!
    
    private var artist: Artist?
    private var cancellable: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.setupCell()
    }
    
    // MARK: Public
    func setup(artist: Artist) {
        self.artist = artist
        self.setupCell()
    }
    
    // MARK: Privates
    private func setupCell() {
        guard let artist = self.artist else {
            return
        }
        
        self.titleLabel.text = artist.name
        self.subtitleLabel.text = "#\(artist.position)"
        self.cancellable = self.loadImage(for: artist.pictureM).sink { [unowned self] image in self.showImage(image: image) }
    }

    private func showImage(image: UIImage?) {
        self.artistImage.image = image
        self.artistImage.clipsToBounds = true
        self.artistImage.layer.cornerRadius = 10
    }
    
    private func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
        .flatMap({ url -> AnyPublisher<UIImage?, Never> in
            let url = URL(string: url)!
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }
    
}
