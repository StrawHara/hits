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
                                                               description: "Find the top and latest hits!\nOr let us make a selection, just for you 🫶🏼",
                                                               previousIsHidden: true)
        case .categories:
            onboardingVM = OnboardingViewController.ViewModel(title: "Top artists",
                                                              image: UIImage(named: "hits"),
                                                              description: "Browse through the latest hottest artists. Sort them by music type, mood, country and more ❤️",
                                                              previousIsHidden: false)
        case .artist:
            onboardingVM = OnboardingViewController.ViewModel(title: "Top hits",
                                                              image: UIImage(named: "artist"),
                                                              description: "It's music time! Catch up and listen to the best and most popular hits out there 🎶",
                                                              previousIsHidden: false)
        case .history:
            onboardingVM = OnboardingViewController.ViewModel(title: "My history",
                                                              image: UIImage(named: "history"),
                                                              description: "Keep track of the hits you've played, so you can play them again and again 🔁",
                                                              previousIsHidden: false)
        case .notification:
            onboardingVM = OnboardingViewController.ViewModel(title: "Don't miss a Hit!",
                                                              image: UIImage(named: "push"),
                                                              description: "FOMO? Receive notifications and be the first one to know when a new hit gets released 🚨",
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
        
        viewController.navigationItem.title = ""
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
