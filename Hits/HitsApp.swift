//
//  HitsApp.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import SwiftUI

@main
struct HitsApp: App {

    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HitsTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:     self.sceneDidBecomeActive()
                    case .inactive:   self.sceneWillResignActive()
                    case .background: self.sceneDidEnterBackground()
                    @unknown default: self.sceneDidSomethingUndefined()
                    }
                }
        }
    }
    
    private func sceneDidBecomeActive() {
        dprint("Scene did become active!")

        URLCache.shared.memoryCapacity = 10_000_000
        URLCache.shared.diskCapacity = 1_000_000_000
    }
    
    private func sceneWillResignActive() {
        dprint("Scene will resign active!")
    }
    
    private func sceneDidEnterBackground() {
        dprint("Scene is now in the background!")
    }
    
    private func sceneDidSomethingUndefined() {
        dprint("Apple must have added something new!")
    }

}
