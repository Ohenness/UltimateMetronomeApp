//
//  ProductCellView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Owen Hennessey on 11/28/23.
//

import SwiftUI

@MainActor
final class TempoViewModel: ObservableObject {
    @Published private(set) var tempo: [Tempo] = []
    
    func getAllTempos(showId: String, partId: String) async throws {
        self.tempo = try await ShowsManager.shared.getAllTempos(showId: showId, partId: partId)
    }
    
    func deleteTempo(showId: String, partId: String, tempoId: String) async throws {
        try await ShowsManager.shared.deleteTempo(showId: showId, partId: partId, tempoId: tempoId)
    }
}

struct TempoView: View {
    let show: Show
    let part: Part
    @StateObject private var viewModel = TempoViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.tempo) { tempo in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Measure \(tempo.measure): \(tempo.tempo) bpm")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                }
                .font(.callout)
                .foregroundColor(.secondary)
                .contextMenu {
                    NavigationLink("Update Tempo") {
                        UpdateTempoView(showId: show.id, partId: part.id, tempo: tempo)
                    }
                    Button("Delete Tempo", role: .destructive) {
                        Task {
                            do {
                                try? await viewModel.deleteTempo(showId: show.id, partId: part.id, tempoId: tempo.id)
                                try? await viewModel.getAllTempos(showId: show.id, partId: part.id)
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
                    CreateTempoView(showId: show.id, partId: part.id)
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            // Refresh the data in ShowPartsView when UpdatePartView is dismissed
            Task {
                try? await viewModel.getAllTempos(showId: show.id, partId: part.id)
            }
        }
    }
}

struct ShowPartsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PartsView(show: Show(showTitle: "", gameYear: ""))
        }
    }
}
