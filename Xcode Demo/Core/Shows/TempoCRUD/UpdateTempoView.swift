//
//  UpdateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct UpdateTempoView : View {
    let showId: String
    let partId: String
    @State var tempo: Tempo
    @Environment(\.presentationMode) var presentationMode
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Measure")) {
                    TextField("Measure", text: $tempo.measure).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Tempo")) {
                    TextField("Tempo", text: $tempo.tempo).textFieldStyle(.roundedBorder)
                }
            }
        }.toolbar {
            ToolbarItem {
                Button("Update") {
                    performUpdate()
                }
            }
        }
    }
    
    private func performUpdate() {
        print("Tempo Updated")
        print("Measure: \(tempo.measure)")
        print("Tempo: \(tempo.tempo)")
        Task {
            do {
                print(tempo)
                try await ShowsManager.shared.createNewTempo(showId: showId, partId: partId, newTempo: tempo)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdateTempoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTempoView(showId: "fakeId", partId: "fakeId", tempo: Tempo(measure: "1", tempo: "132"))
    }
}
