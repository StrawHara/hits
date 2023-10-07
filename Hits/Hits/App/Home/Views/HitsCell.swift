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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setupCollectionView()
        self.setupCell()
    }
    
    // MARK: Public
    func setup(viewModel: HitsViewModel) {
        self.viewModel = viewModel
        self.setupCell()
    }
    
    // MARK: Privates
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //        self.collectionView.alwaysBounceVertical = true
        //        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionView.register(UINib(nibName: ArtistCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: ArtistCell.identifier)
    }
    
    private func setupCell() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.title.text = "France"  // TODO: name
        self.seeMore.titleLabel?.text = "See all" // TODO: trad
        dprint(viewModel.artists.count)
        self.collectionView.reloadData()
    }
    
    // MARK: IBAction
    @IBAction func seeMoreDidTouchedUpInside(_ sender: Any) {
    }
    
}

// MARK: UICollectionViewDelegate
extension HitsCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dprint("didSelectItemAt: \(indexPath.row)")
    }
    
}

// MARK: UICollectionViewDataSource
extension HitsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dprint("❌❌❌❌❌")
        dprint(self.viewModel?.artists.count ?? 0)
        return self.viewModel?.artists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        dprint("❌❌❌❌❌1")
        
        guard let artist = self.viewModel?.artists[indexPath.row],
              let artistCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
            return cell
        }
        dprint("❌❌❌❌❌2")
        
        artistCell.setup(artist: artist)
        cell = artistCell
        dprint("❌❌❌❌❌3")
        
        return cell
    }
    
    
}

extension HitsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50.0
    }
    
}
