//
//  EventTests.swift
//  TicketMasterChallengeTests
//
//  Created by Kristina Borisova on 15/04/2024.
//

import XCTest

@testable import TicketMasterChallenge

final class EventTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testValidEvent() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "event", withExtension: "json") else {
            XCTFail("Missing file: event.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        let event = try? JSONDecoder().decode(Event.self, from: data)
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.id, "Z7r9jZ1AdJ9AK")
        XCTAssertEqual(event?.name, "Minnesota Timberwolves vs. Phoenix Suns")
        XCTAssertEqual(event?.images.count, 10)
    }
    
    func testInvalidEvent() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "eventInvalid", withExtension: "json") else {
            XCTFail("Missing file: eventInvalid.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        let event = try? JSONDecoder().decode(Event.self, from: data)
        
        XCTAssertNil(event)
    }
    
    
    func testValidEventsList() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "eventsList", withExtension: "json") else {
            XCTFail("Missing file: eventsList.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        let events = try? JSONDecoder().decode(EventsList.self, from: data)
        
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.events.count, 20)
    }
    
    func testValidEventDetails() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "eventDetails", withExtension: "json") else {
            XCTFail("Missing file: eventDetails.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        let event = try? JSONDecoder().decode(Event.self, from: data)
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.id, "vv17bZbeGkl9HfMb")
        XCTAssertEqual(event?.name, "P!NK Live 2024")
        XCTAssertEqual(event?.images.count, 11)
        XCTAssertNotNil(event?.promoter)
        XCTAssertEqual(event?.promoter?.id, "653")
        XCTAssertEqual(event?.promoter?.name, "LIVE NATION MUSIC")
        XCTAssertEqual(event?.promoter?.description, "LIVE NATION MUSIC / NTL / USA")
    }

}
