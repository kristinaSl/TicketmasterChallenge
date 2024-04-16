//
//  Event.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

struct Event: Decodable {
    
    let id: String
    let name: String
    let images: [Image]
    let embedded: Embedded
    let dates: Dates
    let promoter: Promoter?

    enum CodingKeys : String, CodingKey {
        case id
        case name
        case images
        case embedded = "_embedded"
        case dates
        case promoter
    }
}

struct EventsList {
    let events: [Event]

    enum ResponseCodingKeys : String, CodingKey {
        case data = "_embedded"
        case page = "page"
    }
    enum CodingKeys: String, CodingKey {
        case events
    }
}

struct EventListPage: Decodable {
    let page: Page
    
    enum CodingKeys: String, CodingKey {
        case page
    }
}

extension EventsList: Decodable {
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: ResponseCodingKeys.self)
        let data = try values.nestedContainer(keyedBy: EventsList.CodingKeys.self, forKey: .data)
        self.events = try data.decode([Event].self, forKey: EventsList.CodingKeys.events)
    }
}
