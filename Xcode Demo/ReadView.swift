//
//  ReadView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct ReadView : View {
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
//                Section {
//                    TextField("Part", text: $newShow.partName).textFieldStyle(.roundedBorder)
//                } header: {
//                    Text("Part")
//                }
//                Section {
//                    TextField("Song", text: $newShow.songName).textFieldStyle(.roundedBorder)
//                } header: {
//                    Text("Song")
//                }
//                Section {
//                    TextField("Tempo", text: $newShow.tempo).textFieldStyle(.roundedBorder)
//                } header: {
//                    Text("Tempo")
//                }
            }
        }.toolbar {
            ToolbarItem {
                Button("Read") {
                    FIRFirestoreService.shared.read(show: newShow.showName)
                }
            }
        }
    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}
