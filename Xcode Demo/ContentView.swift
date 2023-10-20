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
    
    @State var bpm = 140;
    @State var beatsPerMeasure = 4
    @State var player: AVAudioPlayer?
    @State var isPlaying = false
    
    var body: some View {
        
        HStack {
            Spacer()
            Button("-") {
                decTempo()
            }.padding(.leading, 15.0)
            Spacer()
            bpmDisplay(bpm: bpm)
            Spacer()
            Button("+") {
                incTempo()
            }.padding(.trailing, 15.0)
            Spacer()
        }.padding()
        
        Button("Start", systemImage: "play") {
            if isPlaying {
                player?.pause()
                
            } else {
                createAudio()
                player?.play()
            }
            
            isPlaying.toggle()
        }.buttonStyle(.bordered).labelStyle(.iconOnly)
    }
    
    
    
    func bpmDisplay(bpm:Int) -> Text {
        return Text(bpm.codingKey.stringValue + " bpm")
            .font(.largeTitle)
    }
    
    func createAudio() {
        guard let url = Bundle.main.url(forResource: "Metronome", withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 1.0
            player?.rate = 2.0
            player?.numberOfLoops = -1
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }

    func tempo() {
        
    }

    func tempoSettings() {
        
    }

    func incTempo() {
        bpm += 1
        print("Increase tempo")
    }

    func decTempo() {
        bpm -= 1
        print("Decrease tempo")
    }

    func measures() {
        
    }

    func addBeats() {
        
    }

    func subtractBeats() {
        
    }

    func measureCount() {
        
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
