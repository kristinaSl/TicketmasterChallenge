//
//  TicketMasterEventsListScreen.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

final class EventsListScreen: UITestScreen {
    
    private let app = App.shared

    var trait: XCUIElement
    var tableView: XCUIElement
    
    init() {
        trait = app.staticTexts["Events"]
        tableView = app.tables["events-table-view"]
    }
}

// MARK: - UITestScreenNavigable -

extension EventsListScreen: UITestScreenNavigable {
    
    func complete() {
        self.tableView.tap()
    }
    
}
