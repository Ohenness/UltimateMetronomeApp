//
//  CreateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct CreatePartView : View {
    let showId: String
    @State var newPart: Part = Part(partNumber: "", songName: "")
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Song")) {
                    TextField("Song", text: $newPart.songName).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Part Number")) {
                    TextField("Part Number", text: $newPart.partNumber).textFieldStyle(.roundedBorder)
                }
//                Section(header: Text("Tempo")) {
//                    TextField("Tempo", text: $newPart.tempo).textFieldStyle(.roundedBorder)
//                }
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
        print("Part Created")
        print("Song: \(newPart.songName)")
        print("Part Number: \(newPart.partNumber)")
//        print("Tempo: \(newPart.tempo)")
        Task {
            do {
                print(newPart)
                try await ShowsManager.shared.createNewPart(showId: showId, newPart: newPart)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreatePartView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePartView(showId: "fakeID")
    }
}
