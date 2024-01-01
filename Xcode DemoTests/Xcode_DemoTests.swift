//
//  Xcode_DemoTests.swift
//  Xcode DemoTests
//
//  Created by Owen Hennessey on 12/6/23.
//

import XCTest
@testable import Xcode_Demo

final class Xcode_DemoTests: XCTestCase {
    
    var viewModel: MetronomeViewModel!

    @MainActor override func setUp() {
        super.setUp()
        viewModel = MetronomeViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    @MainActor func testToggleMetronomePlayback() {
        let initialPlaybackState = viewModel.isPlaying
        viewModel.toggleMetronomePlayback()
        XCTAssertNotEqual(viewModel.isPlaying, initialPlaybackState, "toggleMetronomePlayback should change the playback state")
    }

    @MainActor func testIncreaseTempo() {
        let initialBpm = viewModel.bpm
        viewModel.incTempo()
        XCTAssertEqual(viewModel.bpm, initialBpm + 1, "incTempo should increase BPM by 1")
    }

    @MainActor func testDecreaseTempo() {
        let initialBpm = viewModel.bpm
        viewModel.decTempo()
        XCTAssertEqual(viewModel.bpm, initialBpm - 1, "decTempo should decrease BPM by 1")
    }

    @MainActor func testAudioCreation() {
        viewModel.createAudio()
        XCTAssertNotNil(viewModel.player, "Player should be initialized after calling createAudio")
    }
    
    @MainActor func testTempoAdjustment() {
        let viewModel = MetronomeViewModel()
        let initialBpm = viewModel.bpm

        viewModel.incTempo()
        XCTAssertEqual(viewModel.bpm, initialBpm + 1, "Incrementing tempo should increase bpm by 1")

        viewModel.decTempo()
        XCTAssertEqual(viewModel.bpm, initialBpm, "Decrementing tempo should decrease bpm back to initial value")
    }

}
