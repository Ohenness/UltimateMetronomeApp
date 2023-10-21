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
    @State var show = ""
    @State var part = ""
    @State var song = ""
    @State var tempo = ""
    
    var body: some View {
        TabView {
            VStack {
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
            }.tabItem {
                Image(systemName: "metronome")
                Text("Metronome")
            }
            VStack {
                Spacer()
                Text("Create").font(.title)
                Form {
                    Section {
                        TextField("Show", text: $show)
                    } header: {
                        Text("Show")
                    }
                    Section {
                        TextField("Part", text: $part)
                    } header: {
                        Text("Part")
                    }
                    Section {
                        TextField("Song", text: $song)
                    } header: {
                        Text("Song")
                    }
                    Section {
                        TextField("Tempo", text: $tempo)
                    } header: {
                        Text("Tempo")
                    }
                }
                HStack {
                    Button("Create") {
                        show = show
                        part = part
                        song = song
                        tempo = tempo
                        print("Varibles assigned")
                        print("Show: \(show)")
                        print("Part: \(part)")
                        print("Song: \(song)")
                        print("Tempo: \(tempo)")

                        FIRFirestoreService.shared.create(show: show, part: part, song: song, tempo: (tempo as NSString) .integerValue )
                        
                    }.padding(.horizontal)
                    Button("Read") {
                        FIRFirestoreService.shared.read()
                    }.padding(.horizontal)
                    Button("Update") {
                        show = show
                        part = part
                        song = song
                        tempo = tempo
                        print("Varibles updated")
                        print("Show: \(show)")
                        print("Part: \(part)")
                        print("Song: \(song)")
                        print("Tempo: \(tempo)")

                        FIRFirestoreService.shared.update(show: show, part: part, song: song, tempo: (tempo as NSString) .integerValue )
                    }.padding(.horizontal)
                    Button("Delete") {
                        FIRFirestoreService.shared.delete()
                    }.padding(.horizontal)
                }
            }
            .tabItem {
                Image(systemName: "firewall")
                Text("CRUD")
            }
            
//            VStack {
//                Text("Read").font(.title)
//                Spacer()
//                Button("Read") {
//                    FIRFirestoreService.shared.read()
//                }.padding(.bottom)
//            }.tabItem {
//                Image(systemName: "firewall")
//                Text("Read")
//            }
        }
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


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
