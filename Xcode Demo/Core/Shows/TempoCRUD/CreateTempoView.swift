//
//  CreateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct CreateTempoView : View {
    let showId: String
    let partId: String
    @State var newTempo: Tempo = Tempo(measure: "", tempo: "")
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Measure")) {
                    TextField("Measure", text: $newTempo.measure).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Tempo")) {
                    TextField("Tempo", text: $newTempo.tempo).textFieldStyle(.roundedBorder)
                }
            }
        }.toolbar {
            ToolbarItem {
                Button("Create") {
                    performCreate()
                }
            }
        }
    }
    
    private func performCreate() {
        print("Tempo Created")
        print("Measure: \(newTempo.measure)")
        print("Tempo: \(newTempo.tempo)")
        Task {
            do {
                print(newTempo)
                try await ShowsManager.shared.createNewTempo(showId: showId, partId: partId, newTempo: newTempo)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreateTempoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTempoView(showId: "fakeId", partId: "fakeId")
    }
}
