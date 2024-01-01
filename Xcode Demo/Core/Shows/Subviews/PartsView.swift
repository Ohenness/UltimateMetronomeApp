//
//  ProductCellView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Owen Hennessey on 11/28/23.
//

import SwiftUI

@MainActor
final class PartsViewModel: ObservableObject {
    @Published private(set) var parts: [Part] = []
    
    func getAllParts(showId: String) async throws {
        self.parts = try await ShowsManager.shared.getAllParts(showId: showId)
    }
    
    func deletePart(showId: String, partId: String) async throws {
        try await ShowsManager.shared.deletePart(showId: showId, partId: partId)
    }
    
    func refreshParts(showId: String) async throws {
        try await getAllParts(showId: showId)
    }
}

struct PartsView: View {
    let show: Show
    @StateObject private var viewModel = PartsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.parts) { part in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Part \(part.partNumber): \(part.songName)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    NavigationLink(destination: TempoView(show: show, part: part)) {
                        
                    }
                }
                .font(.callout)
                .foregroundColor(.secondary)
                .contextMenu {
                    NavigationLink("Update Part") {
                        UpdatePartView(showId: show.id, part: part)
                    }
                    Button("Delete Part", role: .destructive) {
                        Task {
                            do {
                                try? await viewModel.deletePart(showId: show.id, partId: part.id)
                                try? await viewModel.getAllParts(showId: show.id)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(show.showTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreatePartView(showId: show.id)
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            // Refresh the data in ShowPartsView when UpdatePartView is dismissed
            Task {
                try? await viewModel.getAllParts(showId: show.id)
                print("\(show.showTitle): \(viewModel.parts)")
            }
        }
    }
}

struct PartsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PartsView(show: Show(showTitle: "", gameYear: ""))
        }
    }
}
