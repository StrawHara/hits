//
//  DebugPrint.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import Foundation

func dprint<T>(_ object: T) {
  #if DEBUG
    print(object)
  #endif
}
