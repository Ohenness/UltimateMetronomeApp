//
//  CreateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct CreateShowView : View {
    @State var newShow : Show = Show(showTitle: "", gameYear: "")
    @Environment(\.presentationMode) var presentationMode
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $newShow.showTitle).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Game")) {
                    TextField("Game", text: $newShow.gameYear).textFieldStyle(.roundedBorder)
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
    
    func performCreate() {
        print("Create Performed")
        print("Show Title: \(newShow.showTitle)")
        print("Game: \(newShow.gameYear)")
        Task {
            do {
                print(newShow)
                try await ShowsManager.shared.createNewShow(newShow: newShow)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreateShowView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShowView(newShow: Show(showTitle: "Alice in Wonderland", gameYear: "Maryland"))
    }
}
