//
//  OnboardingViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 08/10/2023.
//

import UIKit

final class OnboardingViewController: UIViewController, StoryboardBased {

    struct ViewModel {
        var title: String
        var image: UIImage?
        var description: String
        var previousIsHidden: Bool
        
        init(title: String, image: UIImage?, description: String,
             previousIsHidden: Bool) {
            self.title = title
            self.image = image
            self.description = description
            self.previousIsHidden = previousIsHidden
        }
    }
    
    // MARK: IBOutltets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    
    private var delegate: OnboardingCoordinatorDelegate?
    private var viewModel: ViewModel?
        
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setup(delegate: OnboardingCoordinatorDelegate, viewModel: ViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    private func setupView() {
        guard let viewModel = self.viewModel else {return}
        
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        self.imageView.image = viewModel.image
        self.imageView.layer.cornerRadius = 20
        
        self.continueButton.layer.cornerRadius = 10
        self.previousButton.layer.cornerRadius = 10
        self.previousButton.isHidden = viewModel.previousIsHidden
    }
    
    
    // MARK: IBActions
    @IBAction func continueButtonDidTouchedUp(_ sender: Any) {
        self.delegate?.goToNextStep()
    }
    
    @IBAction func previousButtonDidTouchedUp(_ sender: Any) {
        self.delegate?.goToPreviousStep()
    }
}
