//
//  ContentView.swift
//  Xcode Demo
//
//  Created by Owen Hennessey on 10/6/23.
//

import SwiftUI
import SwiftData
import AVFAudio

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationView {
            List {
                Section("Metronome") {
                    NavigationLink {
                        MetronomeView().navigationTitle("Metronome")
                    } label: {
                        Text("Metronome")
                        Image(systemName: "metronome")
                    }
                }
                Section("CRUD Operations") {
                    NavigationLink {
                        CRUDView().navigationTitle("CRUD")
                    } label: {
                        Text("CRUD Operations")
                        Image(systemName: "firewall")
                    }
                }
                Section("Shows") {
                    NavigationLink("Shows") {
                        ShowView().navigationTitle("Shows")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
