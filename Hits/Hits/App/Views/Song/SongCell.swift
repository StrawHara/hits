//
//  SongCell.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import UIKit
import Combine

final class SongCell: UITableViewCell {
    
    static let identifier = "SongCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var albumCoverImage: UIImageView!
    
    private var song: Song?

    private var cancellable: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setupCell()
    }
    
    // MARK: Public
    func setup(song: Song) {
        self.song = song
        
        self.setupCell()
    }
    
    // MARK: Privates
    private func setupCell() {
        guard let song = self.song else {
            return
        }
        
        self.title.text = song.title
        self.subtitle.text = song.album.title
        self.cancellable = self.loadImage(for: song.album.cover).sink { [unowned self] image in self.showImage(image: image) }
    }
    
    private func showImage(image: UIImage?) {
        self.albumCoverImage.image = image
        self.albumCoverImage.clipsToBounds = true
        self.albumCoverImage.layer.cornerRadius = 10
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

