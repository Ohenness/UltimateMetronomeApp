//
//  MetronomeView.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 11/2/23.
//

import Foundation
import SwiftUI
import AVFAudio

struct MetronomeView : View {
    @State var bpm = 140;
    @State var beatsPerMeasure = 4
    @State var player: AVAudioPlayer?
    @State var isPlaying = false
    
    var body : some View {
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
                print("Pause metronome playback")
            } else {
                createAudio()
                player?.play()
                print("Start metronome playback")
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
            player?.rate = Float(bpm)
            player?.numberOfLoops = -1
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }

    func incTempo() {
        bpm += 1
        print("Increase tempo")
    }

    func decTempo() {
        bpm -= 1
        print("Decrease tempo")
    }
}
