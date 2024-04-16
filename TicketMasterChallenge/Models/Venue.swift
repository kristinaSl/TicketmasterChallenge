//
//  Venue.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 15/04/2024.
//

import Foundation

struct Venue: Decodable {
    
    let id: String
    let name: String
    let city: City
    let state: State?

    enum CodingKeys : String, CodingKey {
        case id
        case name
        case city
        case state
    }
}
