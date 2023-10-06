//
//  HitsTabView.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import SwiftUI

struct HitsTabView: View {
    
    enum Tab {
        case hits
        case player
        case history
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var activeTab = Tab.hits

    init() {}
    
    var body: some View {
        TabView(selection: self.$activeTab) {
            
            // Hits View
            NavigationView {
                LazyView(HitsView())
            }
            .navigationViewStyle(.stack)
            .environment(\.managedObjectContext, viewContext)
            .tabItem { Image(systemName: "chart.bar.fill"); Text("Hits") }
            .tag(Tab.hits)
            
            // Game
            NavigationView {
                LazyView(PlayerView())
            }
            .navigationViewStyle(.stack)
            .environment(\.managedObjectContext, viewContext)
            .tabItem { Image(systemName: "play.circle.fill"); Text("Player") } // TODO: pause.circle.fill
            .tag(Tab.player)
            
            NavigationView {
                LazyView(HistoryView())
            }
            .navigationViewStyle(.stack)
            .environment(\.managedObjectContext, viewContext)
            .tabItem { Image(systemName: "list.triangle"); Text("History") }
            .tag(Tab.history)
            
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
}

#Preview {
    HitsTabView()
}
