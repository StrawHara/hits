//
//  ArtistCell.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit

final class ArtistCell: UICollectionViewCell {
    
    static let identifier = "ArtistCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    
    private var artist: Artist?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.artistImage.cornerRadius = 10
        
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
        // TODO: Image loader
    }

    
}
