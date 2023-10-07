//
//  StateMachine.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation

/*
* StateMachine is creating a pre-defined `Flow` divided by `Steps`
* This protocol can be used in any class who need a well defined flow
*/

/* ************************
   MARK: - Steps definition
   ************************ */

protocol FlowStep: Equatable {}

/* **************************
   MARK: - Flow State Machine
   ************************** */

protocol FlowStateMachine: AnyObject {

    associatedtype Step: FlowStep

    /*
    * MARK: Step definition */
    var steps: [Step] { get set }
    var currentStep: Step? { get set }

    /*
    * MARK: Life cycle */
    var previous: Step? { get }
    var next: Step? { get }
    func run(step: Step) // Need to be declared

    /*
    * MARK: Utils */
    var stepIndex: Int? { get }
    var nbSteps: Int { get }
}

extension FlowStateMachine {

    /*
    * MARK: Life cycle */
    var previous: Step? {
        guard let stepIndex = stepIndex else { return nil }
        guard stepIndex - 1 >= 0 else { return nil }
        return steps[stepIndex - 1]
    }

    var next: Step? {
        guard let stepIndex = stepIndex else { return nil }
        guard stepIndex + 1 < nbSteps else { return nil }
        return steps[stepIndex + 1]
    }

    /*
    * MARK: Utils */
    var stepIndex: Int? {
        guard let currentStep = self.currentStep else { return nil }
        return steps.firstIndex(of: currentStep)
    }
    var nbSteps: Int {
        return steps.count
    }
}

/* ***********************************
   MARK: - Flow default implementation
   *********************************** */

extension FlowStateMachine where Self: CoordinatorFlow {

    func start(fire: Bool) {
        setupSteps()
        guard let currentStep = currentStep else { return }
        didStartHandler?()
        if fire { run(step: currentStep) }
    }

    func nextStep(fire: Bool) {
        guard let currentStep = currentStep, let next = next, currentStep != next else {
            end(error: nil)
            return
        }
        self.currentStep = next
        if fire { run(step: next) }
    }

    func previousStep(fire: Bool) {
        guard let currentStep = currentStep,
            let previous = previous,
            currentStep != previous else {
            end(error: nil)
            return
        }
        self.currentStep = previous
        if fire { run(step: previous) }
    }

    func goToStep(_ step: Step, fire: Bool = true) {
        guard let index = steps.firstIndex(of: step) else {
            end(error: nil)
            return
        }
        self.currentStep = steps[index]
        if fire { run(step: steps[index]) }
    }
}
