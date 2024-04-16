//
//  TicketMasterChallengeUITests.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 14/04/2024.
//

import XCTest

final class TicketMasterChallengeUITests: XCTestCase, NavigationContext {
    
    let app = App.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHappyPath() throws {
        Scenario("Lauching the applications and selecting the first event") {
            Given(I: see(theScreen: eventsListScreen))
            When(I: complete(eventsListScreen))
            Then(I: see(theScreen: eventDetailsScreen))
        }
        
        Scenario("Going back to the main screen") {
            Given(I: see(theScreen: eventDetailsScreen))
            When(I: dismiss(theScreen: eventDetailsScreen))
            Then(I: see(theScreen: eventsListScreen))
        }
    }
}
