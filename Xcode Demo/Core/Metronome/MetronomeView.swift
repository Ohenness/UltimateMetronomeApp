import Foundation
import SwiftUI
import AVFoundation
import UIKit

// MARK: - Shake Gesture Handling

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// MARK: - View Modifier for Shake Gesture

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

@MainActor
final class MetronomeViewModel: ObservableObject {
    @Published var bpm = 140
    @Published var isPlaying = false
    @Published var player: AVAudioPlayer?
    
    func toggleMetronomePlayback() {
        if isPlaying {
            player?.pause()
            print("Pause metronome playback")
        } else {
            createAudio()
            player?.play()
            print("Start metronome playback")
        }
        isPlaying.toggle()
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

// MARK: - MetronomeView

struct MetronomeView: View {
    
    @StateObject private var viewModel = MetronomeViewModel()

    var body: some View {
        VStack {
            Spacer()
            tempoControls
            Spacer()
            playbackButton
                .onShake { viewModel.toggleMetronomePlayback() }
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onDisappear {
            if viewModel.isPlaying {
                viewModel.player?.pause()
                print("Pause metronome playback")
            }
        }
    }

    private var tempoControls: some View {
        HStack {
            Spacer()
            tempoButton("-") { viewModel.decTempo() }
                .padding(.leading, 15.0)
                .accessibilityIdentifier("decreaseTempoButton")
            Spacer()
            bpmDisplay(bpm: viewModel.bpm)
                .foregroundColor(.white)
            Spacer()
            tempoButton("+") { viewModel.incTempo() }
                .padding(.trailing, 15.0)
                .accessibilityIdentifier("increaseTempoButton")
            Spacer()
        }
    }

    private func tempoButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.blue))
                .padding(5)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }

    private var playbackButton: some View {
        Button(action: viewModel.toggleMetronomePlayback) {
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding(20)
                .background(Circle().fill(viewModel.isPlaying ? Color.red : Color.green))
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .padding(5)
                .shadow(radius: 5)
        }
        .accessibilityLabel(viewModel.isPlaying ? "Pause Metronome" : "Play Metronome")
        .accessibilityIdentifier("playbackButton")
    }

    private func bpmDisplay(bpm: Int) -> some View {
        Text("\(bpm) bpm")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .accessibility(identifier: "bpmLabel")
    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
            .preferredColorScheme(.dark) // Set to .light for light mode preview
    }
}
