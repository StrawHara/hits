//
//  OnboardingCoordinator.swift
//  Hits
//
//  Created by Romain Le Drogo on 08/10/2023.
//

import Foundation
import UIKit

enum OnboardingCoordinatorStep: FlowStep {
    case introduction
    case categories
    case artist
    case history
    case notification
}

protocol OnboardingCoordinatorDelegate: AnyObject {
    func goToNextStep()
    func goToPreviousStep()
}

final class OnboardingCoordinator: NSObject, FlowStateMachine, CoordinatorFlow {
    
    enum OnboardingCoordinatorState: Int {
        case never = 0
        case pending
        case finished
    }
    
    /* ******************
        MARK: - Properties
        ****************** */
    
    static let Error: NSError = {
        return NSError(domain: "", code: 0, userInfo: nil)
    }()
    
    var didStartHandler: (() -> Void)?
    var completionHandler: ((_ error: Error?) -> Void)?
    
    var steps: [OnboardingCoordinatorStep] = []
    var currentStep: OnboardingCoordinatorStep?
    
    weak var mainViewController: UIViewController?
    weak var parentCoordinator: AppCoordinator?
    
    var shouldShowOnboarding: Bool = false
    
    static var flowState: OnboardingCoordinatorState {
        get { return OnboardingCoordinatorState(rawValue: UserDefaults.standard.integer(forKey: "onboardingStep")) ?? .never }
        set { UserDefaults.standard.setValue(newValue.rawValue, forKey: "onboardingStep") }
    }
    
    /* ************************
        MARK: - Coordinator Flow
        ************************ */
    
    func setupSteps() {
        assert(steps.isEmpty, "At this stage, `steps` should be empty")
        
        self.steps = [
            .introduction, .categories, .artist, .history, .notification
        ]
        
        currentStep = steps.first
    }
    
    func run(step: OnboardingCoordinatorStep) {
        let onboardingVM: OnboardingViewController.ViewModel
        switch step {
        case .introduction:
            onboardingVM  = OnboardingViewController.ViewModel(title: "Welcome to Hits!",
                                                               image: UIImage(named: "logo"),
                                                               description: "The app who find the Newer & Better Hits, just for you!",
                                                               previousIsHidden: true)
        case .categories:
            onboardingVM = OnboardingViewController.ViewModel(title: "The best Artists",
                                                              image: UIImage(named: "hits"),
                                                              description: "All sorted by categories",
                                                              previousIsHidden: false)
        case .artist:
            onboardingVM = OnboardingViewController.ViewModel(title: "The best Songs",
                                                              image: UIImage(named: "artist"),
                                                              description: "Artist's Top songs",
                                                              previousIsHidden: false)
        case .history:
            onboardingVM = OnboardingViewController.ViewModel(title: "History",
                                                              image: UIImage(named: "history"),
                                                              description: "Never forget a Hit!",
                                                              previousIsHidden: false)
        case .notification:
            onboardingVM = OnboardingViewController.ViewModel(title: "Don't want to miss a Hit?",
                                                              image: UIImage(named: "push"),
                                                              description: "Promise, we would bother you only for urgency Hit case ❤️",
                                                              previousIsHidden: false)
        }
        
        let stepVC = OnboardingViewController.instantiate()
        stepVC.setup(delegate: self, viewModel: onboardingVM)
        stepVC.navigationItem.setHidesBackButton(true, animated: false)
        (self.mainViewController as? UINavigationController)?.pushViewController(stepVC, animated: true)
    }
    
    func end(error: Error? = nil) {
        completionHandler?(error)
    }
        
}

extension OnboardingCoordinator: OnboardingCoordinatorDelegate {
    
    @objc func goToNextStep() {
        nextStep()
    }
    
    func goToPreviousStep() {
        previousStep()
    }
}

extension OnboardingCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        assert(navigationController === self.mainViewController)
        guard navigationController === self.mainViewController else { return nil }
        
        switch operation {
        case .pop: goToPreviousStep(); return nil
        default:   return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard navigationController === mainViewController else { return }
        guard let currentStep = currentStep else { return }
        
        viewController.navigationItem.title = ""
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
