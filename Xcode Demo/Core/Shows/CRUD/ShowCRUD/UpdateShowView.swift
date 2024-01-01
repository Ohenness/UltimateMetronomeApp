//
//  UpdateView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct UpdateShowView : View {
    @State var show : Show
    @Environment(\.presentationMode) var presentationMode
    var body : some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $show.showTitle).textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Game")) {
                    TextField("Game", text: $show.gameYear).textFieldStyle(.roundedBorder)
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
        print("Update Performed")
        print("Show: \(show.gameYear)")
        print("Title: \(show.showTitle)")
        Task {
            do {
                try await ShowsManager.shared.updateShow(show: show)
                print(show)
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdateShowView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateShowView(show: Show(showTitle: "Alice in Borderland", gameYear: "Maryland"))
    }
}
