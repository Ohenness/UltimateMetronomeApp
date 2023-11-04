//
//  DeleteView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct DeleteView : View {
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
            }
        }.toolbar {
            ToolbarItem {
                Button("Delete") {
                    FIRFirestoreService.shared.delete(show: newShow.showName, part: newShow.partName, song: newShow.songName, tempo: (newShow.tempo as NSString) .integerValue )
                }
            }
        }
    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView()
    }
}
