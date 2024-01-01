//
//  Xcode_DemoUITests.swift
//  Xcode DemoUITests
//
//  Created by Owen Hennessey on 12/5/23.
//

import XCTest

final class Xcode_DemoUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    func testToggleMetronomePlayback() throws {
        let app = XCUIApplication()

        // Navigate to MetronomeView if necessary
        let metronomeViewButton = app.buttons["Metronome"]
        if metronomeViewButton.exists {
            metronomeViewButton.tap()
        }
        
        let playbackButton = app.buttons["playbackButton"]
        playbackButton.tap()

        // Check if the button's label has already changed to "Pause Metronome"
        if playbackButton.label == "Pause Metronome" {
            // Button is in pause state
        } else {
            // Wait for the button's state to change to "Pause Metronome"
            let pausePredicate = NSPredicate(format: "label == 'Pause Metronome'")
            expectation(for: pausePredicate, evaluatedWith: playbackButton, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
        }

        playbackButton.tap()

        // Similar check for changing back to "Play Metronome"
        if playbackButton.label == "Play Metronome" {
            // Button is in play state
        } else {
            // Wait for the button's state to change to "Play Metronome"
            let playPredicate = NSPredicate(format: "label == 'Play Metronome'")
            expectation(for: playPredicate, evaluatedWith: playbackButton, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testIncreaseTempo() throws {
        let app = XCUIApplication()

        // Navigate to MetronomeView if necessary
        let metronomeViewButton = app.buttons["Metronome"]
        if metronomeViewButton.exists {
            metronomeViewButton.tap()
        }

        // Find the increase tempo button
        let increaseTempoButton = app.buttons["increaseTempoButton"]
        let bpmLabel = app.staticTexts["bpmLabel"]

        // Tap the increase tempo button
        increaseTempoButton.tap()
        
        // Wait for any change in the BPM label
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: bpmLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Verify the BPM value
        XCTAssertEqual(bpmLabel.label, "141 bpm", "BPM should increase after tapping '+'")
    }
    
    func testDecreaseTempo() {
        let app = XCUIApplication()

        // Navigate to MetronomeView if necessary
        let metronomeViewButton = app.buttons["Metronome"]
        if metronomeViewButton.exists {
            metronomeViewButton.tap()
        }
        
        // Find the increase tempo button
        let decreaseTempoButton = app.buttons["decreaseTempoButton"]
        let bpmLabel = app.staticTexts["bpmLabel"]
        
        // Tap the increase tempo button
        decreaseTempoButton.tap()
        
        // Wait for any change in the BPM label
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: bpmLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(bpmLabel.label, "139 bpm", "BPM should decrease after tapping '-'")
    }

}
