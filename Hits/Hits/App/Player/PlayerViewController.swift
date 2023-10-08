//
//  PlayerViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import UIKit
import Combine
import StoreKit

final class PlayerViewController: UIViewController, StoryboardBased {
    
    private var audioManager: AudioManager?
    private var tabBarDelegate: TabbarDelegate?
    
    @IBOutlet weak var albumCoverImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var queueButton: UIButton!
    
    private var emptyView: EmptyView? = nil

    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Player"
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
        self.showEmptyView()
    }
    
    func setup(audioManager: AudioManager, tabBarDelegate: TabbarDelegate) {
        self.audioManager = audioManager
        self.tabBarDelegate = tabBarDelegate
        self.showEmptyView()
    }
    
    // MARK: Privates
    private func setupView() {
        self.controlsStackView.layer.cornerRadius = 20
        
        self.backwardButton.setTitle("", for: .normal)
        self.backwardButton.setTitle("", for: .selected)
        self.playButton.setTitle("", for: .normal)
        self.playButton.setTitle("", for: .selected)
        self.forwardButton.setTitle("", for: .normal)
        self.forwardButton.setTitle("", for: .selected)
        self.sharebutton.setTitle("", for: .normal)
        self.sharebutton.setTitle("", for: .selected)
        self.queueButton.setTitle("", for: .normal)
        self.queueButton.setTitle("", for: .selected)
    }
    
    private func showEmptyView() {
        let viewIsEmpty = self.audioManager?.playing == nil

        if self.emptyView == nil {
            let emptyView = EmptyView.loadFromNib()
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(emptyView)
            emptyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            emptyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.emptyView = emptyView
            self.emptyView?.setup(delegate: self)
        }
        
        self.emptyView?.isHidden = viewIsEmpty == false
        self.controlsStackView.isHidden = viewIsEmpty == true
        self.sharebutton.isHidden = viewIsEmpty == true
        self.queueButton.isHidden = viewIsEmpty == true
    }
    
    private func refresh() {
        guard let audioManager = self.audioManager,
              let song = self.audioManager?.playing
        else {return}
        
        self.titleLabel.text = song.title
        self.subtitleLabel.text = song.album.title
        self.cancellable = self.loadImage(for: song.album.cover).sink { [unowned self] image in self.showImage(image: image) }
        
        self.playButton.setImage(audioManager.isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
        self.forwardButton.setImage(audioManager.playingQueue.isEmpty ? UIImage(systemName: "forward") : UIImage(systemName: "forward.fill"), for: .normal)
        // TODO: backward with history
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
    
    // MARK: IBActions
    @IBAction func backwardDidTouchedUp(_ sender: Any) {}
    
    @IBAction func playDidTouchedUp(_ sender: Any) {
        if self.audioManager?.isPlaying == true {
            self.audioManager?.pause()
        } else {
            self.audioManager?.play()
        }
        self.refresh()
    }
    
    @IBAction func forwardDidTouchedUp(_ sender: Any) {
        self.audioManager?.next()
        self.refresh()
    }
    
    @IBAction func shareDidTouchedUp(_ sender: Any) {
        guard let songTitle = self.audioManager?.playing?.title else {return}
        
        let text = "Hey! I just discovered this new hit: \"\(songTitle)\". Just amazing 😱 Found it with the -- Hits -- iOS App!\nCheck it out, it's AWESOME!"
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        // If you are sharing something from the app, we can assume that you will leave a good review!
        if #available(iOS 14.0, *) {
            // TODO: --
            // The window should not be used like that - Delegate this to the AppCoordinator - Then use the window available back there
            guard let windowScene = UIApplication.shared.windows.first?.windowScene else {return}
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            // Fallback on earlier versions
        }
    }
    
//    @IBAction func favoriteDidTouchedUp(_ sender: Any) {}
    
    @IBAction func queueDidTouchedUp(_ sender: Any) {
        let queueVC = PlayingQueueViewController()
        queueVC.setup(songs: self.audioManager?.playingQueue ?? [], tabBarDelegate: self.tabBarDelegate)
        self.present(queueVC, animated: true, completion: nil)
    }
}

extension PlayerViewController: EmptyViewDelegate {
    func actionButtonDidTouchedUp() {
        self.tabBarDelegate?.showHits()
        self.dismiss(animated: true)
    }
}
