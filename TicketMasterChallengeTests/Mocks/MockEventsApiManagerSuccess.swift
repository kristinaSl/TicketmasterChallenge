//
//  MockEventsApiManagerSuccess.swift
//  TicketMasterChallengeTests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

@testable import TicketMasterChallenge

class MockEventsApiManagerSuccess: EventsManager {
    func readAll(_ searchTerm: String?, page: Int, completion: @escaping (([Event]?, EventListPage?), Error?) -> Void) {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "eventsList", withExtension: "json") else {
            XCTFail("Missing file: eventsList.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        let eventsList = try? JSONDecoder().decode(EventsList.self, from: data)
        let page = try? JSONDecoder().decode(EventListPage.self, from: data)
        
        completion((eventsList?.events, page), nil)
    }
    
    func read(eventID: String, completion: @escaping (Event?, Error?) -> Void) {
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
        
        completion(event, nil)
    }
}
