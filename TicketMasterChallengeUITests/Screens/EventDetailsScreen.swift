//
//  EventDetailsScreen.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

final class EventDetailsScreen: UITestScreen {
    
    private let app = App.shared

    var trait: XCUIElement
    
    
    init() {
        trait = app.staticTexts["event-details-title-label"]
    }
}

// MARK: - UITestScreenNavigable -

extension EventDetailsScreen: UITestScreenNavigable {
    
    func cancel() {
        self.tapNativeBackButton()
    }
}
