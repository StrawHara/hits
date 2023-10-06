//
//  HitsView.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import SwiftUI

struct HitsView: View {

    @StateObject var viewModel = ArtistsViewModel(service: DeezerService())

    var body: some View {
        VStack {
            List(self.viewModel.artists) { artist in
                HStack {
                    Rectangle()
                    VStack {
                        Text(artist.name)
                    }
                }
            }
        }
        .navigationTitle("Hits")
        .onAppear {
            self.viewModel.fetchArtists()
        }
    }
    
}

#Preview {
    HitsView()
}
