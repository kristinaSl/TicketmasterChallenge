//
//  App.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import Foundation
import XCTest

/**
Singleton in charge of creating XCUIApplication instance and managing the global app state,
This is created so the same application instance can be used across different pages of the app and
the instance we are calling is the one that got launched.
*/
final class App: XCUIApplication {
    static let shared = App()

    private override init() {
        super.init()
        super.launch()
    }
}

