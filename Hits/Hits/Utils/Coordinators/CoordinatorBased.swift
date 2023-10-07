//
//  CoordinatorBased.swift
//  Hits
//
//  Created by Romain Le Drogo on 07/10/2023.
//

import Foundation

/* ************************
   MARK: - CoordinatorBased
   ************************ */

protocol CoordinatorBased {
    var didStartHandler: (() -> Void)? { get set }
    var completionHandler: ((_ error: Error?) -> Void)? { get set }

    mutating func setup(didStart: @escaping () -> Void,
                              completionHandler: @escaping (_ error: Error?) -> Void)
}

extension CoordinatorBased {

    mutating func setup(didStart: @escaping () -> Void,
                              completionHandler: @escaping (_ error: Error?) -> Void) {
        self.didStartHandler = didStart
        self.completionHandler = completionHandler
    }
}
