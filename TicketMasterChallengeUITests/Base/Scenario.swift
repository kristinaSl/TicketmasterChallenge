//
//  Scenario.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

/// Represents a BDD Scenario. Use this to logically group Steps.
struct Scenario {
    
    /// A reference to the most recently created Scenario, useful if you want to find out what scenario failed
    static var current: Scenario?
    
    let description: String
    
    @discardableResult
    init(_ description: String, _ handler: () -> Void) {
        self.description = description
        Scenario.current = self
        XCTContext.runActivity(named: description) { _ in
            handler()
        }
    }
}
