//
//  ShowView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/2/23.
//

import Foundation
import SwiftUI

struct Show : Identifiable {
    var showName : String
    var partName : String
    var songName : String
    var tempo : String
    
    var id = UUID()
}

struct CRUDView : View {
    @State var show = ""
    @State var part = ""
    @State var song = ""
    @State var tempo = ""
    @State var newShow : Show = Show(showName: "", partName: "", songName: "", tempo: "")
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Create") {
                    CreateView()
                        .navigationTitle("Create")
                }
                NavigationLink("Read") {
                    ReadView()
                        .navigationTitle("Read")
                }
                NavigationLink("Update") {
                    UpdateView()
                        .navigationTitle("Update")
                }
                NavigationLink("Delete") {
                    DeleteView()
                        .navigationTitle("Delete")
                }
            }
        }
    }
    
    func clearSelection() {
        
    }
}

    


struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}
