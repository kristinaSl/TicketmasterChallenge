//
//  Embedded.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 15/04/2024.
//

import Foundation

struct Embedded: Decodable {
    let venues: [Venue]
    
    enum CodingKeys : String, CodingKey {
        case venues
    }
}
