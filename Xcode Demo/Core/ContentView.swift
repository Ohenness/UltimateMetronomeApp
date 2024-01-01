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
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationStack {
            List {
                Section("Shows") {
                    NavigationLink("Shows") {
                        ShowsView().navigationTitle("Shows")
                    }
                }
                Section("Metronome") {
                    NavigationLink {
                        MetronomeView()
                    } label: {
                        Text("Metronome")
                        Image(systemName: "metronome")
                    }
                }
//                Section("Profile") {
//                    NavigationLink {
//                        ProfileView(showSignInView: $showSignInView).navigationTitle("Profile")
//                    } label: {
//                        Text("User Profile")
//                    }
//                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                    }
                }
            }
        }
    }
}
