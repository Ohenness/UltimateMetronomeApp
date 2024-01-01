//
//  ShowView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

@MainActor
final class ShowsViewModel: ObservableObject {
    @Published private(set) var shows: [Show] = []
    
    func getAllShows() async throws {
        self.shows = try await ShowsManager.shared.getAllShows()
    }
    
    func deleteShow(showId: String) async throws {
        try await ShowsManager.shared.deleteShow(showId: showId)
    }
}

struct ShowsView : View {
    
    @StateObject private var viewModel = ShowsViewModel()
    
    var body : some View {
        List {
            ForEach(viewModel.shows) { show in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(show.showTitle)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Game: \(show.gameYear)")
                    }
                    NavigationLink(destination: PartsView(show: show)) {
                        
                    }
                }
                .font(.callout)
                .foregroundColor(.secondary)
                .contextMenu {
                    NavigationLink("Update Show") {
                        UpdateShowView(show: show)
                    }
                    Button("Delete Show", role: .destructive) {
                        Task {
                            do {
                                try? await viewModel.deleteShow(showId: show.id)
                                try? await viewModel.getAllShows()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .task {
            try? await viewModel.getAllShows()
            print("Shows: \(viewModel.shows)")
        }
        .navigationTitle("Shows")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreateShowView()
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
    }
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView()
    }
}
