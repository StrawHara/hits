//
//  HitsCell.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import UIKit

final class HitsCell: UITableViewCell {
    
    static let identifier = "HitsCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var seeMore: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: HitsViewModel?
    private var delegate: HomeCoordinatorDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setupCollectionView()
        self.setupCell()
    }
    
    // MARK: Public
    func setup(viewModel: HitsViewModel, delegate: HomeCoordinatorDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        self.setupCell()
    }
    
    // MARK: Privates
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
                
        self.collectionView.register(UINib(nibName: ArtistCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: ArtistCell.identifier)
    }
    
    private func setupCell() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.title.text = viewModel.title
        self.seeMore.titleLabel?.text = "See all" // TODO: trad

        self.collectionView.reloadData()
    }
    
    // MARK: IBAction
    @IBAction func seeMoreDidTouchedUpInside(_ sender: Any) {
    }
    
}

// MARK: UICollectionViewDelegate
extension HitsCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let artistID = self.viewModel?.artists[safe: indexPath.row]?.id {
            self.delegate?.showArtistDetails(artistID: artistID)
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension HitsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.artists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        guard let artist = self.viewModel?.artists[safe: indexPath.row],
              let artistCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
            return cell
        }

        artistCell.setup(artist: artist)
        cell = artistCell
        
        return cell
    }
    
    
}

extension HitsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
    
}
