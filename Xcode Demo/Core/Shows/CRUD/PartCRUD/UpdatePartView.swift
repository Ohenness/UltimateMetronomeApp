//
//  UpdateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct UpdatePartView : View {
    let showId: String
    @State var part: Part
    @Environment(\.presentationMode) var presentationMode
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Song")) {
                    TextField("Song", text: $part.songName).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Part Number")) {
                    TextField("Part Number", text: $part.partNumber).textFieldStyle(.roundedBorder)
                }
//                Section(header: Text("Tempo")) {
//                    TextField("Tempo", text: $part.tempo).textFieldStyle(.roundedBorder)
//                }
                
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
        print("Part Updated")
        print("Song: \(part.songName)")
        print("Part Number: \(part.partNumber)")
//        print("Tempo: \(newPart.tempo)")
        Task {
            do {
                print(part)
                try await ShowsManager.shared.updatePart(showId: showId, part: part)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdatePartView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePartView(showId: "show", part: Part(partNumber: "1", songName: "Wonderland"))
    }
}
