//
//  CreateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct CreateView : View {
    @State var show = ""
    @State var part = ""
    @State var song = ""
    @State var tempo = ""
    @State var newShow : Show = Show(showName: "", partName: "", songName: "", tempo: "")
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    TextField("Show", text: $newShow.showName).textFieldStyle(.roundedBorder)
                } header: {
                    Text("Show")
                }
                Section {
                    TextField("Part", text: $newShow.partName).textFieldStyle(.roundedBorder)
                } header: {
                    Text("Part")
                }
                Section {
                    TextField("Song", text: $newShow.songName).textFieldStyle(.roundedBorder)
                } header: {
                    Text("Song")
                }
                Section {
                    TextField("Tempo", text: $newShow.tempo).textFieldStyle(.roundedBorder)
                } header: {
                    Text("Tempo")
                }
            }
        }.toolbar {
            ToolbarItem {
                Button("Create") {
                    print("Create Performed")
                    print("Show: \(newShow.showName)")
                    print("Part: \(newShow.partName)")
                    print("Song: \(newShow.songName)")
                    print("Tempo: \(newShow.tempo)")
                    FIRFirestoreService.shared.create(show: newShow.showName, part: newShow.partName, song: newShow.songName, tempo: (newShow.tempo as NSString) .integerValue )
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
