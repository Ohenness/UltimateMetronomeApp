//
//  ShowView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/3/23.
//

import Foundation
import SwiftUI

struct ShowView : View {
    var body : some View {
        Text("Shows").font(.largeTitle)
        // Page title "Shows"
        // Sections by show
        // Existing sections provided by persisted data
        // Sections only exist as they exist in the database
    }
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        ShowView()
    }
}
