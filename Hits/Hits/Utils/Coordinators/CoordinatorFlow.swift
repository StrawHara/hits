//
//  CoordinatorFlow.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation
import UIKit

/* ***********************
   MARK: - CoordinatorFlow
   *********************** */

protocol CoordinatorFlow: CoordinatorBased {
    var mainViewController: UIViewController? { get set }

    mutating func setup(didStart: @escaping () -> Void,
                              completionHandler: @escaping (_ error: Error?) -> Void,
                              mainViewController: UIViewController?)

    /*
    * MARK: Flow */
    func start()
    func start(fire: Bool)

    func setupSteps()

    func nextStep()
    func nextStep(fire: Bool)

    func previousStep()
    func previousStep(fire: Bool)

    func end(error: Error?)
}

extension CoordinatorFlow {

    mutating func setup(didStart: @escaping () -> Void,
                              completionHandler: @escaping (_ error: Error?) -> Void,
                              mainViewController: UIViewController? = nil) {
        self.didStartHandler = didStart
        self.completionHandler = completionHandler
    }

    func start() {
        start(fire: true)
    }

    func nextStep() {
        nextStep(fire: true)
    }

    func previousStep() {
        previousStep(fire: false)
    }
}

extension CoordinatorFlow where Self: FlowStateMachine {
    mutating func setup(didStart: @escaping () -> Void,
                              completionHandler: @escaping (_ error: Error?) -> Void,
                              mainViewController: UIViewController? = nil) {
        self.didStartHandler = didStart
        self.completionHandler = completionHandler
        self.mainViewController = mainViewController
        if let nav = mainViewController as? UINavigationController, let s = self as? UINavigationControllerDelegate {
            nav.delegate = s
        }
    }
}
