//
//  MockEventsApiManagerFail.swift
//  TicketMasterChallengeTests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

@testable import TicketMasterChallenge

class MockEventsApiManagerFail: EventsManager {
    
    func readAll(_ searchTerm: String?, page: Int, completion: @escaping (([Event]?, EventListPage?), Error?) -> Void) {
        completion((nil, nil), NSError.init(domain: "API error", code: 0, userInfo: ["userInfo": "test api fail"]))
    }
    
    func read(eventID: String, completion: @escaping (Event?, Error?) -> Void) {
        completion(nil, NSError.init(domain: "API error", code: 0, userInfo: ["userInfo": "test api fail"]))
    }
}
